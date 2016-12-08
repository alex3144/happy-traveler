 $(document).ready(function() {
    $(".dropdown-button").dropdown();
    $('select').material_select();


    // $(".line_1").click(function() {
    //   $(".clouds svg path").attr("fill", "2c3e50");
    // });

    $(".line_5").hover(function() {
      $(".cloud").addClass("hidden");
      $(".sun").removeClass("hidden");
    });
  });

