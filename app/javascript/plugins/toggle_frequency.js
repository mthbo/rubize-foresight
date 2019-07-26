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

const toggleFrequency = () => {
  const applianceCurrentAC = document.querySelector("#appliance_current_type_ac");
  const applianceCurrentDC = document.querySelector("#appliance_current_type_dc");
  const applianceFrequencyFormGroup = document.querySelector("#appliance-frequency-form-group");
  addListener(applianceCurrentAC, applianceCurrentAC, applianceFrequencyFormGroup);
  addListener(applianceCurrentDC, applianceCurrentAC, applianceFrequencyFormGroup);
  const projectCurrentAC = document.querySelector("#project_current_ac");
  const projectFrequencyFormGroup = document.querySelector("#project-frequency-form-group");
  addListener(projectCurrentAC, projectCurrentAC, projectFrequencyFormGroup);
};

export { toggleFrequency };
