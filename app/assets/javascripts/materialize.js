 $(document).ready(function() {
    $(".dropdown-button").dropdown();
    $('select').material_select();

    $('.datepicker').pickadate({
      selectMonths: true,
      selectYears: true,
      dateFormat: 'MM yy'
    });
  });

