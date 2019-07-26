const toggleInverter = () => {
  const acOut = document.querySelector("#power_system_ac_out");
  const inverterFormGroup = document.querySelector("#inverter-form-group");
  if (acOut !== null) {
    acOut.addEventListener("change", (event) => {
      if (acOut.checked) {
        inverterFormGroup.classList.remove('d-none')
      } else {
        inverterFormGroup.classList.add('d-none')
      }
    });
  }
};

export { toggleInverter };
