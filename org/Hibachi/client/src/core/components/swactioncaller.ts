/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWActionCallerController{
    public type:string;
    public confirm:any;
    public action:string;
    public actionItem:string;
    public title:string;
    public class:string;
    public confirmtext:string;
    public disabledtext:string;
    public text:string;
    public disabled:boolean;
    public actionItemEntityName:string;
    public hibachiPathBuilder:any;
    public formCtrl:any;
    public isPublic:string;
    //@ngInject
    constructor(
        private $scope,
        private $element,
        private $templateRequest:ng.ITemplateRequestService,
        private $compile:ng.ICompileService,
        private corePartialsPath,
        private utilityService,
        private $hibachi,
        private rbkeyService,
        hibachiPathBuilder
    ){
        this.$scope = $scope;
        this.$element = $element;
        this.$templateRequest = $templateRequest;
        this.$compile = $compile;
        this.rbkeyService = rbkeyService;
        this.$hibachi = $hibachi;
        this.utilityService = utilityService;
        this.hibachiPathBuilder = hibachiPathBuilder;

        this.$templateRequest(this.hibachiPathBuilder.buildPartialsPath(corePartialsPath)+"actioncaller.html").then((html)=>{
            var template = angular.element(html);
            this.$element.parent().append(template);
            $compile(template)($scope);
            //need to perform init after promise completes
            this.init();
        });
    }

    public init = ():void =>{
//			this.class = this.utilityService.replaceAll(this.utilityService.replaceAll(this.getAction(),':',''),'.','') + ' ' + this.class;
        this.type = this.type || 'link';
        if (this.type == "button" || this.type== "submit" || this.isPublic){
                //handle submit.
                /** in order to attach the correct controller to local vm, we need a watch to bind */
                var unbindWatcher = this.$scope.$watch(() => { return this.$scope.formController; }, (newValue, oldValue) => {
                    if (newValue !== undefined){
                        this.formCtrl = newValue;
                        unbindWatcher();
                    }
                });

            }
            
//			this.actionItem = this.getActionItem();
//			this.actionItemEntityName = this.getActionItemEntityName();
//			this.text = this.getText();
//			if(this.getDisabled()){
//				this.getDisabledText();
//			}else if(this.getConfirm()){
//				this.getConfirmText();
//			}
//
//			if(this.modalFullWidth && !this.getDisabled()){
//				this.class = this.class + " modalload-fullwidth";
//			}
//
//			if(this.modal && !this.getDisabled() && !this.modalFullWidth){
//				this.class = this.class + " modalload";
//			}

        /*need authentication lookup by api to disable
        <cfif not attributes.hibachiScope.authenticateAction(action=attributes.action)>
            <cfset attributes.class &= " disabled" />
        </cfif>
        */
    }
    /** submit function delegates back to the form */
    public submit = () => {
        this.formCtrl.submit(this.action);
    }

    public getAction = ():string =>{

        return this.action || '';
    }

    public getActionItem = ():string =>{
        return this.utilityService.listLast(this.getAction(),'.');
    }

    public getActionItemEntityName = ():string =>{
        var firstFourLetters = this.utilityService.left(this.actionItem,4);
        var firstSixLetters = this.utilityService.left(this.actionItem,6);
        var minus4letters = this.utilityService.right(this.actionItem,4);
        var minus6letters = this.utilityService.right(this.actionItem,6);

        var actionItemEntityName = "";
        if(firstFourLetters === 'list' && this.actionItem.length > 4){
            actionItemEntityName = minus4letters;
        }else if(firstFourLetters === 'edit' && this.actionItem.length > 4){
            actionItemEntityName = minus4letters;
        }else if(firstFourLetters === 'save' && this.actionItem.length > 4){
            actionItemEntityName = minus4letters;
        }else if(firstSixLetters === 'create' && this.actionItem.length > 6){
            actionItemEntityName = minus6letters;
        }else if(firstSixLetters === 'detail' && this.actionItem.length > 6){
            actionItemEntityName = minus6letters;
        }else if(firstSixLetters === 'delete' && this.actionItem.length > 6){
            actionItemEntityName = minus6letters;
        }
        return actionItemEntityName;
    }

    public getTitle = ():string =>{
        //if title is undefined then use text
        if(angular.isUndefined(this.title) || !this.title.length){
            this.title = this.getText();
        }
        return this.title;
    }

    private getTextByRBKeyByAction = (actionItemType:string, plural:boolean=false):string =>{
        var navRBKey = this.rbkeyService.getRBKey('admin.define.'+actionItemType+'_nav');

        var entityRBKey = '';
        var replaceKey = '';
        if(plural){
            entityRBKey = this.rbkeyService.getRBKey('entity.'+this.actionItemEntityName+'_plural');
            replaceKey = '${itemEntityNamePlural}';
        }else{
            entityRBKey = this.rbkeyService.getRBKey('entity.'+this.actionItemEntityName);
            replaceKey = '${itemEntityName}';
        }

        return this.utilityService.replaceAll(navRBKey,replaceKey, entityRBKey);
    }

    public getText = ():string =>{
        //if we don't have text then make it up based on rbkeys
        if(angular.isUndefined(this.text) || (angular.isDefined(this.text) && !this.text.length)){
            this.text = this.rbkeyService.getRBKey(this.utilityService.replaceAll(this.getAction(),":",".")+'_nav');
            var minus8letters = this.utilityService.right(this.text,8);
            //if rbkey is still missing. then can we infer it
            if(minus8letters === '_missing'){
                var firstFourLetters = this.utilityService.left(this.actionItem,4);
                var firstSixLetters = this.utilityService.left(this.actionItem,6);
                var minus4letters = this.utilityService.right(this.actionItem,4);
                var minus6letters = this.utilityService.right(this.actionItem,6);

                if(firstFourLetters === 'list' && this.actionItem.length > 4){
                    this.text = this.getTextByRBKeyByAction('list' ,true);
                }else if(firstFourLetters === 'edit' && this.actionItem.length > 4){
                    this.text = this.getTextByRBKeyByAction('edit' ,false);
                }else if(firstFourLetters === 'save' && this.actionItem.length > 4){
                    this.text = this.getTextByRBKeyByAction('save' ,false);
                }else if(firstSixLetters === 'create' && this.actionItem.length > 6){
                    this.text = this.getTextByRBKeyByAction('create' ,false);
                }else if(firstSixLetters === 'detail' && this.actionItem.length > 6){
                    this.text = this.getTextByRBKeyByAction('detail' ,false);
                }else if(firstSixLetters === 'delete' && this.actionItem.length > 6){
                    this.text = this.getTextByRBKeyByAction('delete' ,false);
                }
            }

            if(this.utilityService.right(this.text,8)){
                this.text = this.rbkeyService.getRBKey(this.utilityService.replaceAll(this.getAction(),":","."));
            }

        }
        if(!this.title || (this.title && !this.title.length)){
            this.title = this.text;
        }

        return this.text
    }

    public getDisabled = ():boolean =>{
        //if item is disabled
        if(angular.isDefined(this.disabled) && this.disabled){
            return true;
        }else{
            return false;
        }
    }

    public getDisabledText = ():string =>{
        if(this.getDisabled()){
            //and no disabled text specified
            if(angular.isUndefined(this.disabledtext) || !this.disabledtext.length ){
                var disabledrbkey = this.utilityService.replaceAll(this.action,':','.')+'_disabled';
                this.disabledtext = this.rbkeyService.getRBKey(disabledrbkey);
            }
            //add disabled class
            this.class += " btn-disabled";
            this.confirm = false;
            return this.disabledtext;
        }

        return "";
    }

    public getConfirm = ():boolean =>{
        if(angular.isDefined(this.confirm) && this.confirm){
            return true;
        }else{
            return false;
        }
    }

    public getConfirmText = ():string =>{
        if(this.getConfirm() ){
            if(angular.isUndefined(this.confirmtext) && this.confirmtext.length){
                var confirmrbkey = this.utilityService.replaceAll(this.action,':','.')+'_confirm';
                this.confirmtext = this.rbkeyService.getRBKey(confirmrbkey);
                /*<cfif right(attributes.confirmtext, "8") eq "_missing">
                    <cfset attributes.confirmtext = replace(attributes.hibachiScope.rbKey("admin.define.delete_confirm"),'${itemEntityName}', attributes.hibachiScope.rbKey('entity.#actionItemEntityName#'), "all") />
                </cfif>*/
            }
            this.class += " alert-confirm";
            return this.confirm;
        }
        return "";
    }
}


interface IActionCallerScope extends ng.IScope {
    formController: ng.IFormController
}
class SWActionCaller implements ng.IDirective{
    public restrict:string = 'EA';
    public scope:any={};
    public bindToController:any={
        action:"@",
        text:"@",
        type:"@",
        queryString:"@",
        title:"@",
        'class':"@",
        icon:"@",
        iconOnly:"=",
        name:"@",
        confirm:"=",
        confirmtext:"@",
        disabled:"=",
        disabledtext:"@",
        modal:"=",
        modalFullWidth:"=",
        id:"@",
        isPublic: "@?"
    };
    public controller=SWActionCallerController;
    public controllerAs="swActionCaller";
    public require="^?swForm"
    public templateUrl;
    
    public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = () => new SWActionCaller();
        return directive;
    }

    constructor(){}

    public link:ng.IDirectiveLinkFn = (scope: IActionCallerScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, formController) =>{
        if (angular.isDefined(formController)){
            scope.formController = formController;    
        }
    }
}

export{
    SWActionCaller,
    SWActionCallerController
}

