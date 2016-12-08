 $(document).ready(function() {
    $(".dropdown-button").dropdown();
    $('select').material_select();


    $(".line_1").click(function() {
      $(".arrow_1").removeClass("hidden");
      $(".arrow_3, .arrow_4").addClass("hidden");
    });

    $(".line_3").click(function() {
      $(".arrow_3").removeClass("hidden");
      $(".arrow_1, .arrow_4").addClass("hidden");
    });

    $(".line_4").click(function() {
      $(".arrow_4").removeClass("hidden");
      $(".arrow_1, .arrow_3").addClass("hidden");
    });

    $(".line_5").hover(function() {
      $(".cloud").addClass("hidden");
      $(".sun").removeClass("hidden");
    });
  });

