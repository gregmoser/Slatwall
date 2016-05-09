/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWFormFieldRevertHelperController {
    
    public parentDirectiveControllerAs;
    public parentDirectiveBindProperty; 
    public valueToRevertTo;

    // @ngInject
    constructor(private $hibachi
        ){
    }
}

class SWFormFieldRevertHelper implements ng.IDirective{

    public templateUrl;
    public restrict = "EA";
    public require = "ngModel";
    public scope = {};

    public bindToController = {
        parentDirectiveControllerAs:"@",
        parentDirectiveBindProperty:"=",
        valueToRevertToProperty:"="
    };
    public controller=SWFormFieldRevertHelper;
    public controllerAs="swFormFieldRevertHelper";

    // @ngInject
    constructor(){

    }

    public link:ng.IDirectiveLinkFn = ($scope, element: ng.IAugmentedJQuery, attrs:any, modelCtrl: ng.INgModelController) =>{

         var parentScope = $scope.$parent;
         var parentDirectiveScope = parentScope[$scope.swFormFieldRevertHelper.parentDirectiveControllerAs];

         modelCtrl.$parsers.unshift((inputValue) =>{
            var modelValue = modelCtrl.$modelValue;
            
            //figure out if the model value has changed
            //was it a revert?
            if(modelValue !== inputValue && angular.isDefined(parentDirectiveScope)){
                parentDirectiveScope.valueToRevertTo = modelValue;
                parentDirectiveScope[parentDirectiveScope.property] = inputValue; 
                parentDirectiveScope.edited = true; 
            }
                
            return modelValue;
        });


    }

    public static Factory(){
        var directive:ng.IDirectiveFactory = (

        )=> new SWFormFieldRevertHelper(

        );
        directive.$inject = [

        ];
        return directive;
    }
}
export{
    SWFormFieldRevertHelper,
    SWFormFieldRevertHelperController
}