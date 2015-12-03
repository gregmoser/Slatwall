/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
//services
import {WorkflowConditionService} from "./services/workflowconditionservice";

//directives
import {SWAdminCreateSuperUser} from "./components/swadmincreatesuperuser";
import {SWWorkflowBasic} from "./components/swworkflowbasic";
import {SWWorkflowCondition} from "./components/swworkflowcondition";
import {SWWorkflowConditionGroupItem} from "./components/swworkflowconditiongroupitem";
import {SWWorkflowConditionGroups} from "./components/swworkflowconditiongroups";
import {SWWorkflowTask} from "./components/swworkflowtask";
import {SWWorkflowTaskActions} from "./components/swworkflowtaskactions";
import {SWWorkflowTasks} from "./components/swworkflowtasks";
import {SWWorkflowTrigger} from "./components/swworkflowtrigger";
import {SWWorkflowTriggers} from "./components/swworkflowtriggers";

//filters


var workflowmodule = angular.module('hibachi.workflow',[]).config(()=>{
})
//constants
.constant('workflowPartialsPath','workflow/components/')
//services
.service('workflowConditionService',WorkflowConditionService)
//directives
.directive('swAdminCreateSuperUser',SWAdminCreateSuperUser.Factory())
.directive('swWorkflowBasic',SWWorkflowBasic.Factory())
.directive('swWorkflowCondition',SWWorkflowCondition.Factory())
.directive('swWorkflowConditionGroupItem',SWWorkflowConditionGroupItem.Factory())
.directive('swWorkflowConditionGroups',SWWorkflowConditionGroups.Factory())
.directive('swWorkflowTask',SWWorkflowTask.Factory())
.directive('swWorkflowTaskActions',SWWorkflowTaskActions.Factory())
.directive('swWorkflowTasks',SWWorkflowTasks.Factory())
.directive('swWorkflowTrigger',SWWorkflowTrigger.Factory())
.directive('swWorkflowTriggers',SWWorkflowTriggers.Factory())
//filters

;
export{
	workflowmodule
}