const updateRefreshButton = () => {
  const useInput = document.querySelector("#appliance_use_id");
  const refreshButton = document.querySelector("#refresh_load");
  let useId = useInput.options[useInput.selectedIndex].value;
  useInput.addEventListener("change", (event) => {
    useId = useInput.options[useInput.selectedIndex].value;
    refreshButton.setAttribute('href', '/refresh_load?use_id=' + useId)
  });
};



export { updateRefreshButton };
