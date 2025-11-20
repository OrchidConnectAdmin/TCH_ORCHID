(function (root, factory) {

    if (typeof define === 'function' && define.amd) {
        define(factory);
    } else if (typeof exports === 'object') {
        module.exports = factory();
    } else {
        root.PC = root.PortalCommon = factory();

        function AuraPromise(executor) {
            if (executor) {
                this.innerPromise = new Promise(executor);
            }
        }

        AuraPromise.all = function (promises) {
            var auraPromise = new AuraPromise();
            auraPromise.innerPromise = Promise.all(promises);
            return auraPromise;
        };

        AuraPromise.prototype.catch = function (onError) {
            this.innerPromise = this.innerPromise.catch($A.getCallback(onError));
            return this;
        };

        AuraPromise.prototype.finally = function (onFinally) {
            this.innerPromise = this.innerPromise.finally($A.getCallback(onFinally));
            return this;
        };

        AuraPromise.prototype.then = function (resolve, reject) {
            this.innerPromise = this.innerPromise.then(resolve ? $A.getCallback(resolve) : null, reject ? $A.getCallback(reject) : null);
            return this;
        };
        root.AuraPromise = AuraPromise;
    }

}(this, function () {
    return {
        toArray: function(itemOrArray) {
            if (itemOrArray instanceof Array) {
                return itemOrArray;
            }
            return [itemOrArray];
        },
        processCatalogsIntoTree: function (flatCatalogs, currentView) {
            return this._processCatalogsIntoTree(flatCatalogs, undefined, currentView);
        },
        _processCatalogsIntoTree: function (allCats, parentId, currentView) {
            allCats.forEach(function (cat) {
                cat.href = '#/store/browse/cat/' + cat.id + '/' + currentView;
                cat.url = cat.href;
                cat.label = cat.name;
            });
            var self = this;
            var roots = allCats.filter(function (cat) { return cat.parent === parentId; });
            roots.forEach(function (root) {
                root.children = self._processCatalogsIntoTree(allCats, root.id, currentView);
                root.childMenuItems = root.children;
            });
            return roots;
        },
        hasCatalogItems: function (catalogs) {
            //generate children nodes
            catalogs.forEach(function (cat) {
                cat.children = catalogs.filter(function (c) { return c.parent === cat.id; });
            });
            return this._hasCatalogItems(catalogs);
        },
        _hasCatalogItems: function (catalogs) {
            return this.toArray(catalogs).filter(function (cat) {
                //you're good if you have items or if one of your children does
                return cat.hasItems || this._hasCatalogItems(cat.children).length > 0;
            }.bind(this));
        },
        processCatalogsFlat: function (catalogs, currentView) {
            return catalogs.map(function (cat) {
                cat.href = '#/store/browse/cat/' + cat.id + '/' + currentView;
                cat.url = cat.href;
                cat.label = cat.name;

                cat.children = catalogs.filter(function (c) { return c.parent === cat.id; });
                return cat;
            })
        },
    }
}));
