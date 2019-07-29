const addListener = (changingInput, checkedInput, formGroup) => {
  if (changingInput !== null) {
    changingInput.addEventListener("change", (event) => {
      if (checkedInput.checked) {
        formGroup.classList.remove('d-none')
      } else {
        formGroup.classList.add('d-none')
      }
    });
  }
};

const toggleInverter = () => {
  const powerSystemAcOutTrue = document.querySelector("#power_system_ac_out_true");
  const powerSystemAcOutFasle = document.querySelector("#power_system_ac_out_false");
  const inverterFormGroup = document.querySelector("#inverter-form-group");
  addListener(powerSystemAcOutTrue, powerSystemAcOutTrue, inverterFormGroup);
  addListener(powerSystemAcOutFasle, powerSystemAcOutTrue, inverterFormGroup);
};

export { toggleInverter };
