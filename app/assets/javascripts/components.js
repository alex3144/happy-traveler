 $(document).ready(function() {

  $(".line_1").click(function() {
    $(".arrow_1_target").removeClass("hidden");
    $(".arrow_1").removeClass("hidden");
    $(".arrow_2_target, .arrow_3_target, .arrow_4_target, .arrow_0_target").addClass("hidden");
    $(".arrow_2, .arrow_3, .arrow_4").addClass("hidden");

  });

  $(".line_2").click(function() {
    $(".arrow_2_target").removeClass("hidden");
    $(".arrow_2").removeClass("hidden");
    $(".arrow_1, .arrow_3, .arrow_4").addClass("hidden");
    $(".arrow_1_target, .arrow_3_target, .arrow_4_target, .arrow_0_target").addClass("hidden");
  });


  $(".line_3").click(function() {
    $(".arrow_3_target").removeClass("hidden");
    $(".arrow_3").removeClass("hidden");
    $(".arrow_1, .arrow_2, .arrow_4").addClass("hidden");
    $(".arrow_1_target, .arrow_2_target, .arrow_4_target, .arrow_0_target").addClass("hidden");
  });

  $(".line_4").click(function() {
    $(".arrow_4_target").removeClass("hidden");
    $(".arrow_4").removeClass("hidden");
    $(".arrow_1, .arrow_2, .arrow_3").addClass("hidden");
    $(".arrow_1_target, .arrow_2_target, .arrow_3_target, .arrow_0_target").addClass("hidden");
  });


  $(".line_5").click(function() {
    $(".frame").removeClass("hidden_animation");
    $(".cloud").addClass("hidden_animation");
    $(".container").addClass("hidden");
  });

  $(".arrow_1_target").click(function(){
    $('#periode').focus().click();
  });

  $(".arrow_2_target").click(function(){
    $('#departure').focus().click();
  });

  $(".arrow_3_target").click(function(){
    $('#destination').focus().click();
  });

});
