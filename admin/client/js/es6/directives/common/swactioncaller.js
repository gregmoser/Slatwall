/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWActionCallerController {
        constructor(utilityService, $slatwall) {
            this.utilityService = utilityService;
            this.$slatwall = $slatwall;
            this.getAction = () => {
                return this.action;
            };
            this.getActionItem = () => {
                return this.utilityService.listLast(this.action, '.');
            };
            this.getActionItemEntityName = () => {
                var firstFourLetters = this.utilityService.left(this.getActionItem(), 4);
                var firstSixLetters = this.utilityService.left(this.getActionItem(), 6);
                var minus4letters = this.utilityService.right(this.getActionItem(), 4);
                var minus6letters = this.utilityService.right(this.getActionItem(), 6);
                var actionItemEntityName = "";
                if (firstFourLetters === 'list' && this.getActionItem().length > 4) {
                    actionItemEntityName = minus4letters;
                }
                else if (firstFourLetters === 'edit' && this.getActionItem().length > 4) {
                    actionItemEntityName = minus4letters;
                }
                else if (firstFourLetters === 'save' && this.getActionItem().length > 4) {
                    actionItemEntityName = minus4letters;
                }
                else if (firstSixLetters === 'create' && this.getActionItem().length > 6) {
                    actionItemEntityName = minus6letters;
                }
                else if (firstSixLetters === 'detail' && this.getActionItem().length > 6) {
                    actionItemEntityName = minus6letters;
                }
                else if (firstSixLetters === 'delete' && this.getActionItem().length > 6) {
                    actionItemEntityName = minus6letters;
                }
                return actionItemEntityName;
            };
            this.getTitle = () => {
                //if title is undefined then use text
                if (angular.isUndefined(this.title) || !this.title.length) {
                    this.title = this.text;
                }
                return this.title;
            };
            this.getTextByRBKeyByAction = (actionItemType, plural = false) => {
                var navRBKey = this.$slatwall.getRBKey('admin.define.' + actionItemType + '_nav');
                if (plural) {
                    var entityRbKey = this.$slatwall('entity.' + this.getActionItemEntityName() + '_plural');
                    var replaceKey = '${itemEntityNamePlural}';
                }
                else {
                    var entityRbKey = this.$slatwall('entity.' + this.getActionItemEntityName());
                    var replaceKey = '${itemEntityName}';
                }
                return this.utilityService.replaceAll(navRBKey, replaceKey, entityRBKey);
            };
            this.getText = () => {
                //if we don't have text then make it up based on rbkeys
                if (angular.isUndefined(this.text) || (angular.isDefined(this.text) && !this.text.length)) {
                    this.text = this.$slatwall.getRBKey(this.utilityService.replaceAll(getAction(), ":", ".") + '_nav');
                    var minus8letters = this.utilityService.right(this.text, 8);
                    //if rbkey is still missing. then can we infer it
                    if (minus8letters === '_missing') {
                        var firstFourLetters = this.utilityService.left(this.getActionItem(), 4);
                        var firstSixLetters = this.utilityService.left(this.getActionItem(), 6);
                        var minus4letters = this.utilityService.right(this.getActionItem(), 4);
                        var minus6letters = this.utilityService.right(this.getActionItem(), 6);
                        if (firstFourLetters === 'list' && this.getActionItem().length > 4) {
                            this.text = this.getTextByRBKeyByAction('list', true);
                        }
                        else if (firstFourLetters === 'edit' && this.getActionItem().length > 4) {
                            var navRBKey = this.$slatwall.getRBKey('admin.define.edit_nav');
                            var entityRbKey = this.$slatwall('entity.' + this.getActionItemEntityName());
                            this.text = this.utilityService.replaceAll(navRBKey, '${itemEntityName}', entityRBKey);
                        }
                        else if (firstFourLetters === 'save' && this.getActionItem().length > 4) {
                            var navRBKey = this.$slatwall.getRBKey('admin.define.save_nav');
                            var entityRbKey = this.$slatwall('entity.' + this.getActionItemEntityName());
                            this.text = this.utilityService.replaceAll(navRBKey, '${itemEntityName}', entityRBKey);
                        }
                        else if (firstSixLetters === 'create' && this.getActionItem().length > 6) {
                            var navRBKey = this.$slatwall.getRBKey('admin.define.create_nav');
                            var entityRbKey = this.$slatwall('entity.' + this.getActionItemEntityName());
                            this.text = this.utilityService.replaceAll(navRBKey, '${itemEntityName}', entityRBKey);
                        }
                        else if (firstSixLetters === 'detail' && this.getActionItem().length > 6) {
                            actionItemEntityName = minus6letters;
                        }
                        else if (firstSixLetters === 'delete' && this.getActionItem().length > 6) {
                            actionItemEntityName = minus6letters;
                        }
                        return actionItemEntityName;
                    }
                }
                return this.text;
            };
            this.getDisabled = () => {
                //if item is disabled
                if (angular.isDefined(this.disabled) && this.disabled) {
                    return true;
                }
                else {
                    return false;
                }
            };
            this.getDisabledText = () => {
                if (this.getDisabled()) {
                    //and no disabled text specified
                    if (angular.isUndefined(this.disabledtext) || !this.disabledtext.length) {
                        var disabledrbkey = this.utilityService.replaceAll(this.action, ':', '.') + '_disabled';
                        this.disabledtext = $slatwall.getRBKey(disabledrbkey);
                    }
                    //add disabled class
                    this.class += " s-btn-disabled";
                    this.confirm = false;
                    return this.disabledtext;
                }
                return "";
            };
            this.getConfirm = () => {
                if (angular.isDefined(this.confirm) && this.confirm) {
                    return true;
                }
                else {
                    return false;
                }
            };
            this.getConfirmText = () => {
                if (this.getConfirm()) {
                    if (angular.isUndefined(this.confirmtext) && this.confirmtext.length) {
                        var confirmrbkey = this.utilityService.replaceAll(this.action, ':', '.') + '_confirm';
                        this.confirmtext = $slatwall.getRBKey(confirmrbkey);
                    }
                    this.class += " alert-confirm";
                    return this.confirm;
                }
                return "";
            };
            //if text is blank or undefined
            if (angular.isUndefined(this.text) || (angular.isDefined(this.text) && this.text.length && angular.isUndefined(this.icon))) {
            }
            /*
            <cfif attributes.modal && not attributes.disabled && not attributes.modalFullWidth >
                <cfset attributes.class &= " modalload" />
            </cfif>
            
            <cfif not attributes.hibachiScope.authenticateAction(action=attributes.action)>
                <cfset attributes.class &= " disabled" />
            </cfif>
            */
            /*
            <cfif attributes.hibachiScope.authenticateAction(action=attributes.action) || (attributes.type eq "link" && attributes.iconOnly)>
                <cfif attributes.type eq "link">
                    <cfoutput><a title="#attributes.title#" class="#attributes.class#" target="_self" href="#attributes.hibachiScope.buildURL(action=attributes.action,querystring=attributes.querystring)#"<cfif attributes.modal && not attributes.disabled> data-toggle="modal" data-target="##adminModal"</cfif><cfif attributes.disabled> data-disabled="#attributes.disabledtext#"<cfelseif attributes.confirm> data-confirm="#attributes.confirmtext#"</cfif><cfif len(attributes.id)>id="#attributes.id#"</cfif>>#attributes.icon##attributes.text#</a></cfoutput>
                <cfelseif attributes.type eq "list">
                    <cfoutput><li><a title="#attributes.title#" class="#attributes.class#" target="_self" href="#attributes.hibachiScope.buildURL(action=attributes.action,querystring=attributes.querystring)#"<cfif attributes.modal && not attributes.disabled> data-toggle="modal" data-target="##adminModal"</cfif><cfif attributes.disabled> data-disabled="#attributes.disabledtext#"<cfelseif attributes.confirm> data-confirm="#attributes.confirmtext#"</cfif><cfif len(attributes.id)>id="#attributes.id#"</cfif>>#attributes.icon##attributes.text#</a></li></cfoutput>
                <cfelseif attributes.type eq "button">
                    <cfoutput><button class="#attributes.class#" title="#attributes.title#"<cfif len(attributes.name)> name="#attributes.name#" value="#attributes.action#"</cfif><cfif attributes.modal && not attributes.disabled> data-toggle="modal" data-target="##adminModal"</cfif><cfif attributes.disabled> data-disabled="#attributes.disabledtext#"<cfelseif attributes.confirm> data-confirm="#attributes.confirmtext#"</cfif><cfif attributes.submit>type="submit"</cfif><cfif len(attributes.id)>id="#attributes.id#"</cfif>>#attributes.icon##attributes.text#</button></cfoutput>
                <cfelseif attributes.type eq "submit">
                    <cfoutput>This action caller type has been discontinued</cfoutput>
                </cfif>
            </cfif>
            */
        }
    }
    slatwalladmin.SWActionCallerController = SWActionCallerController;
    class SWActionCaller {
        constructor(partialsPath, utiltiyService, $slatwall) {
            this.partialsPath = partialsPath;
            this.utiltiyService = utiltiyService;
            this.$slatwall = $slatwall;
            this.restrict = 'E';
            this.scope = {};
            this.transclude = true;
            this.bindToController = {
                action: "@",
                text: "@",
                type: "@",
                queryString: "@",
                title: "@",
                class: "@",
                icon: "@",
                iconOnly: "=",
                name: "@",
                confirm: "=",
                confirmtext: "@",
                disabled: "=",
                disabledtext: "@",
                modal: "=",
                modalFullWidth: "=",
                id: "@"
            };
            this.controller = SWActionCallerController;
            this.controllerAs = "swActionCaller";
            this.link = (scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + 'actioncaller.html';
        }
    }
    slatwalladmin.SWActionCaller = SWActionCaller;
    angular.module('slatwalladmin').directive('swActionCaller', ['partialsPath', 'utilityService', '$slatwall', (partialsPath, utilityService, $slatwall) => new SWActionCaller(partialsPath, utilityService, $slatwall)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swactioncaller.js.map