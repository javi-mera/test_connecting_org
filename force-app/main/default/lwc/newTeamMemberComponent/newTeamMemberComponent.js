import { LightningElement, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getRecordNotifyChange } from "lightning/uiRecordApi";
import createNewTeamMember from "@salesforce/apex/NewTeamMemberController.createNewTeamMember";
import deleteTeamMember from "@salesforce/apex/NewTeamMemberController.deleteTeamMember";
import getProjectTeamMembers from "@salesforce/apex/NewTeamMemberController.getProjectTeamMembers";

const actions = [{ label: "Delete", name: "delete" }];

const columns = [
  { label: "User", fieldName: "userName" },
  { label: "Member role", fieldName: "memberRole" },
  { label: "Access Level", fieldName: "accessLevel" },
  {
    type: "action",
    typeAttributes: { rowActions: actions }
  }
];

export default class NewTeamMemberComponent extends LightningElement {
  error;
  isShowModal = false;
  selectedUserId;
  @api recordId;

  data = [];
  columns = columns;
  record = {};

  getTeamMembers() {
    getProjectTeamMembers({ projectId: this.recordId })
      .then((result) => {
        console.log(result);
        this.data = result;
      })
      .catch((error) => {
        console.log(error);
        this.error = error;
        let errorMessage = "Error loading team members:";
        if (error.body.pageErrors[0]) {
          errorMessage += error.body.pageErrors[0].message;
        }
        this.showNotification(errorMessage, "error");
      });
  }

  connectedCallback() {
    this.getTeamMembers();
  }

  handleRowAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    switch (actionName) {
      case "delete":
        this.deleteRow(row);
        break;
      case "show_details":
        this.showRowDetails(row);
        break;
      default:
    }
  }

  deleteRow(row) {
    deleteTeamMember({
      teamMemberId: row.teamMemberId,
      projectId: this.recordId
    })
      .then((result) => {
        console.log(result);
        this.showNotification("Team member delete successfully", "success");
        this.getTeamMembers();
      })
      .catch((error) => {
        console.log(error);
        this.error = error;
        let errorMessage = "Error deleting team member:";
        if (error.body.pageErrors[0]) {
          errorMessage += error.body.pageErrors[0].message;
        }
        this.showNotification(errorMessage, "error");
      });
  }

  findRowIndexById(id) {
    let ret = -1;
    this.data.some((row, index) => {
      if (row.id === id) {
        ret = index;
        return true;
      }
      return false;
    });
    return ret;
  }

  showModalBox() {
    this.isShowModal = true;
  }

  hideModalBox() {
    this.isShowModal = false;
  }

  handleUserSelection(event) {
    this.selectedUserId = event.target.value;
    console.log("userId: " + this.selectedUserId);
  }

  handleSave() {
    console.log("ok");
    console.log("record" + this.recordId);
    createNewTeamMember({
      projectId: this.recordId,
      teamMemberUserId: this.selectedUserId
    })
      .then((result) => {
        console.log(result);
        this.showNotification("Team member created successfully", "success");
        getRecordNotifyChange([
          { recordId: this.recordId },
          { recordId: result.Id }
        ]);
        this.hideModalBox();
        this.getTeamMembers();
      })
      .catch((error) => {
        console.log(error);
        this.error = error;
        let errorMessage = "Error creating team member:";
        if (error.body.pageErrors[0]) {
          errorMessage += error.body.pageErrors[0].message;
        }
        this.showNotification(errorMessage, "error");
      });
  }

  showNotification(message, variant) {
    const evt = new ShowToastEvent({
      title: "",
      message: message,
      variant: variant,
      mode: "dismissible"
    });
    this.dispatchEvent(evt);
  }
}