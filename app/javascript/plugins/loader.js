const toggleLoader = () => {
  let forceClose = false;
  const $customLoader = $("#custom-loader");
  $customLoader.on('shown.bs.modal', function() {
    console.log("shown.bs.modal");
    console.log(forceClose);
    if (forceClose) {
      $customLoader.modal('hide');
      console.log("force closing");
      console.log(forceClose);
    }
  });
  $customLoader.on('hidden.bs.modal', function() {
    forceClose = false;
    console.log("hidden.bs.modal");
    console.log(forceClose);
  });
  document.body.addEventListener('ajax:send', function(event) {
    $customLoader.modal('show');
    console.log("ajax:send");
    console.log(forceClose);
  });
  document.body.addEventListener('ajax:complete', function(event) {
    forceClose = true;
    $customLoader.modal('hide');
    console.log("ajax:complete");
    console.log(forceClose);
  });
};

export { toggleLoader };
