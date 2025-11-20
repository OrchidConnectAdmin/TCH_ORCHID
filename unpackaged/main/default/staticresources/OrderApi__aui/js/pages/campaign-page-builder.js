var panelList,
    items,
    testdrag,
    $iframe;

panelList = $('#draggablePanelList');
$iframe = $('.selCompWrapper iframe');

function autoResize(id) {
  var frameHeight = 200;
  var frameWidth = 400;
  var frameId = 'iframe__' + id;
  frameHeight = document.getElementById(frameId).contentWindow.document.body.scrollHeight;
  frameWidth = document.getElementById(frameId).contentWindow.document.body.scrollWidth;
  document.getElementById(frameId).height= (frameHeight) + "px";
  document.getElementById(frameId).width= (frameWidth) + "px";
}

// fires on ready
$(function(){
  regHandlers();
  $iframe.zoomer({
    width: '100%',
    zoom: 0.8
  });
});

function regHandlers() {

  // Build the Items Array
  buildItemsArray();

  $('.createCls').click(function(e) {
    e.preventDefault();
    var aId = $(this).attr('id');
    var componentName = aId.substr(0, aId.indexOf('-comp'));
    createElementAF(componentName);
  });

  // Make the panels draggable
  panelList.sortable({
    items: "li:not(.placeholder)",
    update: sortableRemoteActionUpdateFunction
  });

  $('.draggable').draggable({
    revert: "invalid",
    cursor: 'move',
    opacity: 0.7,
    helper: "clone",
    zIndex: 999,
    connectToSortable: '#draggablePanelList',
    appendTo: 'body',
    start: function(event, ui) {
      $(this).hide();
    },
    stop: function(event, ui) {
      $(this).show();
    }
  });

  panelList.droppable({
    drop: function(event, ui) {
      var dragId = ui.draggable.attr('id');
      var compName = ui.draggable.attr('name');
      if (typeof dragId == 'undefined') {
        dragId = ui.draggable.attr('compid');
      }
      var dropId = $(this).attr("id");
      var elemId;
      if (typeof dragId == 'undefined' || dragId.indexOf('comp_') != -1) {
        if (typeof dragId == 'undefined') {
          elemId = 'newElement';
        } else {
          elemId = 'pgelem_' + dragId.split('comp_')[1];
        }
        var newList = $('<li class="pageElementBlock" id="' + elemId + '" name="' + compName + '"><div style="height:150px;width:150px;"><h2>' + compName + '</h2></div></li>');
        $(ui.draggable).html(newList);
        var orderPos = items.length;
        buildItemsArray();
        window.location.href = getPageElementUrl(orderPos,compName);
      }
    }
  });

}

function buildItemsArray() {
  items = [];
  $('.pageElementBlock', panelList).each(function(index, elem) {
    var $listItem = $(elem);
    var newId = $listItem.attr('id');
    var item = {};
    item.elementid = newId;
    var recId;
    if (newId.indexOf('pgelem_') != -1) {
      item.id = newId.split('pgelem_')[1];
      recId = newId.split('pgelem_')[1];
    } else {
      item.id = null;
      recId = newId.split('elem_')[1];
    }
    item.order = index + 1;
    items.push(item);
  });
}

function editElement(elementId) {
  editElementAF(elementId);
}

function deleteElement(elementId) {
  if (confirm('Are you sure?'))
    deleteElementAF(elementId);
}
