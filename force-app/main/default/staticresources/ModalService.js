(function() {
    setTimeout(() => {
        const liElement = document.createElement('li');
        liElement.setAttribute('data-target-selection-name', 'SetOutOfTheOffice');
        liElement.classList.add(...['slds-button', 'slds-button--neutral']);
        liElement.addEventListener('click', function() {
            document.querySelector('c-modal-service').showModal();
        })
        const aHrefElement = document.createElement('a');
        aHrefElement.href = 'javascript:void(0);';
        aHrefElement.title = 'Set Out Of The Office';
        aHrefElement.classList.add('forceActionLink');
        const divElement = document.createElement('div');
        divElement.title = 'Set Out Of The Office';
        divElement.innerText = 'Set Out Of The Office';
        aHrefElement.appendChild(divElement);
        liElement.appendChild(aHrefElement);
        document.querySelector('.flexipageBaseRecordHomeTemplateDesktop .branding-actions').appendChild(liElement);

    }, 250)
})();