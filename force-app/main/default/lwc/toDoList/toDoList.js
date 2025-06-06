import { LightningElement, track, wire} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getTaskList from '@salesforce/apex/toDoList.getTaskList';
import getTasksBySubject from '@salesforce/apex/toDoList.getTasksBySubject';
export default class TaskFunctionality extends NavigationMixin(LightningElement) {
    @track tasks = [];
    @track addedTasks = [];
    @track showDropdown = false;
    @track selectedTasks = [];
    isInternalClick = false;
    @track checkedTasks = new Set();
    error;
    connectedCallback() {
        getTaskList().then(result => {
            this.tasks = result;
        }).catch(error => console.error(error));
        
        const storedTasks = localStorage.getItem('addedTasks');
        if (storedTasks) {
            this.addedTasks = JSON.parse(storedTasks);
        }
        document.addEventListener('mousedown', this.handleOutsideClick);
        }
        disconnectedCallback() {
            document.removeEventListener('mousedown', this.handleOutsideClick);
        }
        handleOutsideClick = (event) => {
            if (this.isInternalClick) {
                this.isInternalClick = false;
                return;
            }
            this.showDropdown = false;
        }
    handleInternalClick() {
        this.isInternalClick = true;
    }
    handleFocus() {
        this.showDropdown = true;
    }
    handleCheckboxChange(event){
        const taskId = event.currentTarget.dataset.id;
        if(event.target.checked){
            this.selectedTasks.push(taskId);
        }else if(!(event.target.checked)){
            this.selectedTasks = this.selectedTasks.filter(Id => Id != taskId);
        }
    }
    handleClick(){
        if (!this.selectedTasks || this.selectedTasks.length === 0) {
            console.warn('No contacts selected for addding it to the To Do List');
            return;
        }
        const selected = this.tasks.filter(task => this.selectedTasks.includes(task.Id));
        const newTasks = selected.filter(task => !this.addedTasks.some(t => t.Id === task.Id));
        this.addedTasks = [...this.addedTasks, ...newTasks];
        localStorage.setItem('addedTasks', JSON.stringify(this.addedTasks));
        this.selectedTasks = [];
        this.showDropdown = false;
    }
    handleRemove(event){
        const taskId = event.currentTarget.dataset.id;
        this.addedTasks = this.addedTasks.filter(task => task.Id !== taskId);
        localStorage.setItem('addedTasks', JSON.stringify(this.addedTasks));
    }
    navigateToRecord(event) {
        const taskId = event.currentTarget.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: taskId,
                objectApiName: 'Task',
                actionName: 'view'
            }
        });
    }
    handleStrikeCheckboxChange(event) {
        const taskId = event.currentTarget.dataset.id;
        if (event.target.checked) {
            this.checkedTasks.add(taskId);
        } else {
            this.checkedTasks.delete(taskId);
        }
        this.addedTasks = this.addedTasks.map(task => {
            return {
                ...task,
                strikeClass: this.checkedTasks.has(task.Id) ? 'strike-through' : ''
            };
        });
    }
}