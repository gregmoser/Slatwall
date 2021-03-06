/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWProcessCallerController{
	public utilityService;
	public type:string;
	public queryString:string;
	public static $inject = ['$templateRequest','$compile','corePartialsPath','$scope','$element','$transclude','utilityService',
			'hibachiPathBuilder'];
	constructor(public $templateRequest:ng.ITemplateRequestService, public $compile:ng.ICompileService,public corePartialsPath,public $scope,public $element,public $transclude:ng.ITranscludeFunction,utilityService,
			hibachiPathBuilder){
		this.$templateRequest = $templateRequest;
		this.$compile = $compile;
		this.corePartialsPath = corePartialsPath;
		this.utilityService = utilityService;
		this.type = this.type || 'link';
		this.queryString = this.queryString || '';
		this.$scope = $scope;
		this.$element = $element;
		this.$transclude = this.$transclude;
		this.$templateRequest(hibachiPathBuilder.buildPartialsPath(this.corePartialsPath)+"processcaller.html").then((html)=>{
			var template = angular.element(html);
			this.$element.parent().append(template);
			$compile(template)(this.$scope);
		});
	}
}

class SWProcessCaller implements ng.IDirective{

	public restrict:string = 'E';
	public scope = {};
	public bindToController={
		action:"@",
		entity:"@",
		processContext:"@",
		hideDisabled:"=",
		type:"@",
		queryString:"@",
		text:"@",
		title:"@",
		'class':"@",
		icon:"=",
		iconOnly:"=",
		submit:"=",
		confirm:"=",
		disabled:"=",
		disabledText:"@",
		modal:"="
	};
	public controller=SWProcessCallerController
	public controllerAs="swProcessCaller";
	public static $inject = ['corePartialsPath','utilityService'];
	constructor(private corePartialsPath,private utilityService){
		this.corePartialsPath = corePartialsPath;
		this.utilityService = utilityService;
	}

	public static Factory(){
		var directive = (
			corePartialsPath,utilityService
		)=> new SWProcessCaller(
			corePartialsPath,utilityService
		);
		directive.$inject = [
			'corePartialsPath','utilityService'
		];
		return directive;
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
	}
}
 export{
	 SWProcessCaller
 }



