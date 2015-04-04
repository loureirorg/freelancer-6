// ----------------------------
// INDEX
// ----------------------------
$(document).on('ready page:load', function() {

  // specific code for this controller / action
  var right = (($('body').data('controller') == 'grievances') && (($('body').data('action') == 'index') || ($('body').data('action') == 'search') || ($('body').data('action') == 'my_grievances') || ($('body').data('action') == 'new_grievances') || ($('body').data('action') == 'changed_grievances')));
  if (! right) return ;

  //====================================================================================//

  // GET A LIST OF CITIES WHEN STATE WAS CHANGED
  $('#filter-state').change(function () {
    $.getJSON('/cities/' + $(this).val(), function (data) {

      // clear
      $('#filter-city').empty();

      // default
      var opt = "<option value=''>-- All Cities --</option>";
      $('#filter-city').append(opt);

      // process list
      $.each(data, function(key, val) {
        var opt = "<option value='" + val + "'>" + val + "</option>";
        $('#filter-city').append(opt);
      });
    });
  });


  //====================================================================================//

  // COP SELECT
  $('#filter-cop').select2({
    placeholder: '-- All Cops --',
    dropdownAutoWidth: 'true',
    allowClear: true,
    ajax: {
      url: '/cops/search',
      dataType: 'json',
      data: function (term, page) { return { q: term } },
      results: function (data, page) { return { results: data } }
    },
    formatResult: function (item) { return item.badge_number + ' - ' + item.name },
    formatSelection: function (item) { return item.badge_number + ' - ' + item.name },
    escapeMarkup: function (m) { return m },
    formatInputTooShort: function (input, min) { return $(this.element).prop('placeholder') },
    initSelection: function(element, callback) { 
      callback({id: element.val(), name: element.data('name'), badge_number: element.data('badge')}) 
    },
  });

  //====================================================================================//

  // click on tr = "show" action
  $('#grievance-table').on('click', 'tr > td', function (e) {
    if ($(this).find('a').length == 0) {
      Turbolinks.visit($(this).closest('tr').data('show-path'));
    }
  });

  //====================================================================================//

});


// ----------------------------
// _FORM
// ----------------------------
$(document).on('ready page:load', function() {

  // specific code for this controller / action
  var right = (($('body').data('controller') == 'grievances') && (($('body').data('action') == 'edit') || ($('body').data('action') == 'new') || ($('body').data('action') == 'create') || ($('body').data('action') == 'update')));
  if (! right) return ;

  //====================================================================================//

  // GET A LIST OF CITIES WHEN STATE WAS CHANGED
  $('#grievance_state_name').change(function () {
    $.getJSON('/cities/' + $(this).val(), function (data) {

      // clear
      $('#grievance_city_name').empty();

      // default
      var opt = "<option value=''>-- Select a City --</option>";
      $('#grievance_city_name').append(opt);

      // process list
      $.each(data, function(key, val) {
        var opt = "<option value='" + val + "'>" + val + "</option>";
        $('#grievance_city_name').append(opt);
      });
    });
  });

  //====================================================================================//

  // COP SELECT
  function copFormatResult(item) {
    if (item.is_new) {
      var markup = '<span class="fa fa-plus-square"></span> Add new ...';
    }
    else {
      var markup = item.badge_number + ' - ' + item.name;
    }
    return markup;
  }

  $('#grievance_cop_id').select2({
    placeholder: 'Choose a Cop',
    dropdownAutoWidth: 'true',
    ajax: {
      url: '/cops/search',
      dataType: 'json',
      data: function (term, page) { return { q: term } },
      results: function (data, page) { return { results: data } }
    },
    formatResult: copFormatResult,
    formatSelection: function (item) { return item.badge_number + ' - ' + item.name },
    escapeMarkup: function (m) { return m },
    formatInputTooShort: function (input, min) { return $(this.element).prop('placeholder') },
    initSelection: function(element, callback) { 
      callback({id: element.val(), name: element.data('name'), badge_number: element.data('badge')}) 
    },
    createSearchChoice:function(term, data) { if ($(data).filter(function () { return (typeof this.text != "undefined") && this.text.localeCompare(term)===0; }).length===0) {return {id:term, name:term, is_new: true};} },
    createSearchChoicePosition: 'bottom'
  }).on('select2-selecting', function (e) {
    // "+ add new ...": open dialog
    if (e.choice.is_new) {
      $('#btn-new-cop').click();
    }
  });

  // open "create cop" dialog
  $('#new-cop').on('shown.bs.modal', function () {
    $('#cop-name').val($('#grievance_cop_id').select2('data').name);
    $('#cop-badge').val(''); //clear
    $('#cop-badge').focus();
  });

  // "save" on "create cop" dialog
  $('#form-cop').submit(function (e) {
    e.preventDefault();
    $('#new-cop').modal('hide'); // closes dialog
    $('#grievance_cop_id').select2('data', {id: null, name: $('#cop-name').val(), badge_number: $('#cop-badge').val()});
    $('input[name="grievance[cop_name]"]').val($('#cop-name').val());
    $('input[name="grievance[cop_badge]"]').val($('#cop-badge').val());
    $('input[name="grievance[cop_race]"]').val($('#cop-race').val());
    $('#grievance_title').focus();
  });

  // "cancel" on "create cop" dialog
  $('#btn-cancel-cop').click(function (e) {
    e.preventDefault();
    $('#new-cop').modal('hide'); // closes dialog
    $('#grievance_cop_id').select2('data', null);
    $('input[name="grievance[cop_name]"]').val('');
    $('input[name="grievance[cop_badge]"]').val('');
    $('#grievance_cop_id').select2('focus');
  });

  //====================================================================================//

  // CONNECTED GRIEVANCES

  $('#grievance_connected_grievances_ids').select2({
    placeholder: 'Search by code, cop, date, title',
    dropdownAutoWidth: 'true',
    ajax: {
      url: '/connected-grievances/search',
      dataType: 'json',
      data: function (term, page) { return { q: term } },
      results: function (data, page) { return { results: data } }
    },
    tags: true,
    tokenSeparators: [",", " "],
    multiple: true,
    formatResult: function (item) { return '#' + item.id + ' (' + item.date_incident + ')' + ' - ' + item.city_name + ', ' + item.state_name + ', ' + item.cop_name + ', ' + item.title },
    formatSelection: function (item) { return item.id + ' - ' + item.title.split(" ").splice(0,3).join(" ") },
    escapeMarkup: function (m) { return m },
    initSelection: function(element, callback) { callback(element.data("info")) },
  });


  //====================================================================================//

  // FOCUS
  $('#grievance_cop_id').select2('focus');

  //====================================================================================//

  // DATE
  $("input.date").datepicker();
  //====================================================================================//
});