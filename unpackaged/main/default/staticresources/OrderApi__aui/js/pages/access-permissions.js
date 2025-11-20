
/**
 * Adds selected items and moves them to the
 * selected list on the right
 */
$('.add').click(function(){
  $('.all').prop("checked",false);
  var items = $("#optionList input:checked:not('.all')");
  var n = items.length;
  if (n > 0) {
    items.each(function(idx,item) {
      var choice = $(item);
      choice.prop("checked",false);
      choice.parent().appendTo("#selectedList");
    });
  } else {
    alert("Choose an item from list 1");
  }
});

/**
 * Removes selected items and moves them to the
 * unselected list on the left
 */
$('.remove').click(function(){
  $('.all').prop("checked",false);
  var items = $("#selectedList input:checked:not('.all')");
  items.each(function(idx,item) {
    var choice = $(item);
    choice.prop("checked",false);
    choice.parent().appendTo("#optionList");
  });
});

/**
 * Selects all items in a given list group
 */
$('.all').click(function(e){
  e.stopPropagation();
  var $this = $(this);
  if ($this.is(":checked")) {
    $this.parents('.list-group').find("[type=checkbox]").prop("checked",true);
  } else {
    $this.parents('.list-group').find("[type=checkbox]").prop("checked",false);
      $this.prop("checked",false);
  }
});

$('[type=checkbox]').click(function(e){
  e.stopPropagation();
});

/**
 * Toggles checkbox when an item is
 * selected
 */
$('.list-group a.list-group-item').click(function(e) {
  e.stopPropagation();
  var $this = $(this).find("[type=checkbox]");
  if ($this.is(":checked")) {
    $this.prop("checked",false);
  } else {
    $this.prop("checked",true);
  }
  if ($this.hasClass("all")) {
    $this.trigger('click');
  }
});

/**
 * Submits selected badge type ids to the database
 */
$('#save').click(function(e){
  e.stopPropagation();
  var items = $("#selectedList .list-group-item:not('.header')");
  var badgeTypeIds = [];
  items.each(function(idx,item){
    var choice = $(item);
    badgeTypeIds[idx] = choice.attr('data-badge-type-id');
  });
  var inputIds = $("input[id$='permIds']");
  inputIds.val(badgeTypeIds);
  savePerms();
});
