import { LightningElement, track, wire } from 'lwc';

import insertForm from '@salesforce/apex/formDemo.insertForm';

import getFormData from '@salesforce/apex/formDemo.getFormData';

import { refreshApex } from '@salesforce/apex';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class FormDemo extends LightningElement {

    @track name = '';
    @track email = '';
    @track city = '';
    isDisabled = true;

    wiredFormDataResult;
    @track formData = [];

    @wire(getFormData)
        wiredFormData(result) {
            this.wiredFormDataResult = result;
            if (result.data) {
                this.formData = result.data;
            } else if (result.error) {
                this.formData = [];
                console.log(result.error);
            }
        }

    handleInputChange(event){
        const field = event.target.name;
        const value = event.target.value;

        if(field == 'name'){
            this.name = value;
        }else if(field == 'email'){
            this.email = value;
        }else if(field == 'city'){
            this.city = value;
        }

       if (this.name && this.email && this.city) {
            this.isDisabled = false;
        } else {
            this.isDisabled = true;
        }
    }

    handleClick(event){
       const formRecord = {
            Name: this.name,
            Email__c: this.email,
            City__c: this.city
        };
        insertForm({ formRecord })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Form record created successfully!',
                        variant: 'success'
                    })
                );
                this.name = '';
                this.email = '';
                this.city = '';
                this.isDisabled = true;

                 return refreshApex(this.wiredFormDataResult);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
    }