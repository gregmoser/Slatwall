<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->

<cfoutput>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>#rc.pageTitle# &##124; Slatwall</title>
		
		<link rel="icon" href="#request.slatwallScope.getBaseURL()#/assets/images/favicon.png" type="image/png" />
		<link rel="shortcut icon" href="#request.slatwallScope.getBaseURL()#/assets/images/favicon.png" type="image/png" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		
		<link href="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/css/bootstrap.min.css" rel="stylesheet">
		<link href="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/css/jquery-ui-1.8.16.custom.css" rel="stylesheet">
		<link href="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/css/global.css" rel="stylesheet">
		
		<script type="text/javascript">
			var slatwall = {
				dateFormat : '#request.slatwallScope.setting("globalDateFormat")#'
				,timeFormat : '#request.slatwallScope.setting("globalTimeFormat")#'
				,rootURL : '#request.slatwallScope.getBaseURL()#'
			};
		</script>
	</head>
	<body>
		<div class="navbar navbar-fixed-top">
			<div class="navbar-inner">
				<div class="container-fluid">
					<ul class="nav">
						<!---
						<a href="#application.configBean.getContext()#/admin" class="brand"><img src="#request.slatwallScope.getBaseURL()#/assets/images/mura.logo.png" style="width:25px;heigh:26px;" title="Mura" /></a>
						<li class="divider-vertical"></li>
						--->
						<cfset homeLink = request.slatwallScope.getBaseURL() />
						<cfif not len(homeLink)>
							<cfset homeLink = "/" />
						</cfif>
						<a href="#homeLink#" class="brand brand-two"><img src="#request.slatwallScope.getBaseURL()#/assets/images/admin.logo.png" style="width:100px;heigh:16px;" title="Slatwall" /></a>
						<li class="divider-vertical"></li>
						<cf_HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.products_nav')#" icon="tags icon-white" type="nav">
							<cf_HibachiActionCaller action="admin:entity.listproduct" type="list">
							<cf_HibachiActionCaller action="admin:entity.listproducttype" type="list">
							<cf_HibachiActionCaller action="admin:entity.listoptiongroup" type="list">
							<cf_HibachiActionCaller action="admin:entity.listbrand" type="list">
							<cf_HibachiActionCaller action="admin:entity.listsubscriptionterm" type="list">
							<cf_HibachiActionCaller action="admin:entity.listsubscriptionbenefit" type="list">
							<cf_HibachiActionCaller action="admin:entity.listproductreview" type="list">
							<cf_HibachiActionCaller action="admin:entity.listpromotion" type="list">
							<cf_HibachiActionCaller action="admin:entity.listpricegroup" type="list">
						</cf_HibachiActionCallerDropdown>
						<cf_HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.orders_nav')#" icon="inbox icon-white" type="nav">
							<cf_HibachiActionCaller action="admin:entity.listorder" type="list">
							<cf_HibachiActionCaller action="admin:entity.listcartandquote" type="list">
							<cf_HibachiActionCaller action="admin:entity.listorderitem" type="list">
							<cf_HibachiActionCaller action="admin:entity.listorderfulfillment" type="list">
							<cf_HibachiActionCaller action="admin:entity.listorderpayment" type="list">
							<cf_HibachiActionCaller action="admin:entity.listvendororder" type="list">
							<cf_HibachiActionCaller action="admin:entity.listvendororderitem" type="list">
						</cf_HibachiActionCallerDropdown>
						<cf_HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.accounts_nav')#" icon="user icon-white" type="nav">
							<cf_HibachiActionCaller action="admin:entity.listaccount" type="list">
							<cf_HibachiActionCaller action="admin:entity.listvendor" type="list">
							<cf_HibachiActionCaller action="admin:entity.listsubscriptionusage" type="list">
							<cf_HibachiActionCaller action="admin:entity.listpermissiongroup" type="list">
						</cf_HibachiActionCallerDropdown>
						<cf_HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.warehouse_nav')#" icon="barcode icon-white" type="nav">
							<cf_HibachiActionCaller action="admin:entity.liststockreceiver" type="list">
							<cf_HibachiActionCaller action="admin:entity.liststockadjustment" type="list">
						</cf_HibachiActionCallerDropdown>
						<cf_HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.integrations_nav')#" icon="random icon-white" type="nav">
							<cf_HibachiActionCaller action="admin:entity.listintegration" type="list">
							<cfset local.integrationSubsystems = request.slatwallScope.getService('integrationService').getActiveFW1Subsystems() />
							<cfloop array="#local.integrationSubsystems#" index="local.intsys">
								<cfif request.slatwallScope.authenticateAction('#local.intsys.subsystem#:main.default')>
									<li>
										<a href="#buildURL(action='#local.intsys.subsystem#:main.default')#">#local.intsys.name#</a>
									</li>
								</cfif>
							</cfloop>
						</cf_HibachiActionCallerDropdown>
						<cf_HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.settings_nav')#" icon="cog icon-white" type="nav">
							<cfsavecontent variable="local.settingGroupOne">
								<cf_HibachiActionCaller action="admin:entity.settings" title="#$.slatwall.rbKey('admin.setting_nav')#" type="list">
								<cf_HibachiActionCaller action="admin:entity.listattributeset" type="list" divideAfter="true">
							</cfsavecontent>
							<cfif len(local.settingGroupOne)>
								#local.settingGroupOne#
								<li class="divider"></li>
							</cfif>
							<cf_HibachiActionCaller action="admin:entity.listaddresszone" type="list">
							<cf_HibachiActionCaller action="admin:entity.listcategory" type="list">
							<cf_HibachiActionCaller action="admin:entity.listcontent" type="list" divideAfter="true">
							<cf_HibachiActionCaller action="admin:entity.listcountry" type="list">
							<cf_HibachiActionCaller action="admin:entity.listcurrency" type="list">
							<cf_HibachiActionCaller action="admin:entity.listemail" type="list">
							<cf_HibachiActionCaller action="admin:entity.listemailtemplate" type="list">
							<cf_HibachiActionCaller action="admin:entity.listfulfillmentmethod" type="list">
							<cf_HibachiActionCaller action="admin:entity.listlocation" type="list">
							<cf_HibachiActionCaller action="admin:entity.listmeasurementunit" type="list">
							<cf_HibachiActionCaller action="admin:entity.listorderorigin" type="list">
							<cf_HibachiActionCaller action="admin:entity.listpaymentmethod" type="list">
							<cf_HibachiActionCaller action="admin:entity.listpaymentterm" type="list">
							<cf_HibachiActionCaller action="admin:entity.listroundingrule" type="list">
							<cf_HibachiActionCaller action="admin:entity.listsite" type="list">
							<cf_HibachiActionCaller action="admin:entity.listtaxcategory" type="list">
							<cf_HibachiActionCaller action="admin:entity.listterm" type="list">
							<cf_HibachiActionCaller action="admin:entity.listtype" type="list">
						</cf_HibachiActionCallerDropdown>
						<cf_HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.tools_nav')#" icon="magnet icon-white" type="nav">
							<cfsavecontent variable="local.toolGroupOne">
								<cf_HibachiActionCaller action="admin:main.about" type="list">
								<cf_HibachiActionCaller action="admin:main.log" type="list">
								<cf_HibachiActionCaller action="frontend:page.slatwall-productlisting" text="#$.slatwall.rbKey('admin.frontendexample')#" type="list">
							</cfsavecontent>
							<cfif len(local.toolGroupOne)>
								#local.toolGroupOne#
								<li class="divider"></li>
							</cfif>
							<cfsavecontent variable="local.toolGroupTwo">
								<cf_HibachiActionCaller action="admin:main.ckfinder" type="list" modal="true" />
								<cf_HibachiActionCaller action="admin:entity.listschedule" type="list">
								<cf_HibachiActionCaller action="admin:entity.listtask" type="list">
								<cf_HibachiActionCaller action="admin:entity.listtaskhistory" type="list">
							</cfsavecontent>
							<cfif len(local.toolGroupTwo)>
								#local.toolGroupTwo#
								<li class="divider"></li>
							</cfif>
							<cf_HibachiActionCaller action="admin:main.update" type="list">
							<cfif $.slatwall.getCurrentAccount().getSuperUserFlag()>
								<cf_HibachiActionCaller action="admin:main.default" querystring="reload=true&update=true" type="list" text="Reload Slatwall (Full Update)">
								<cf_HibachiActionCaller action="admin:main.default" querystring="reload=true" type="list" text="Reload Slatwall">
							</cfif>
						</cf_HibachiActionCallerDropdown>
						
					</ul>
					<cfif $.slatwall.getLoggedInAsAdminFlag()>
						<div class="pull-right">
							<ul class="nav">
								<cf_HibachiActionCallerDropdown title="" icon="user icon-white" dropdownclass="pull-right" type="nav">
									<cf_HibachiActionCaller action="admin:entity.detailaccount" querystring="accountID=#$.slatwall.account('accountID')#" type="list">
									<cf_HibachiActionCaller action="admin:main.logout" type="list">
								</cf_HibachiActionCallerDropdown>
								<li class="divider-vertical"></li>
							</ul>
							<form name="search" class="navbar-search" action="/" onSubmit="return false;">
								<input id="global-search" type="text" name="serach" class="search-query span2" placeholder="Search">
							</form>
							
						</div>
					</cfif>
				</div>
			</div>
		</div>
		<div id="search-results" class="search-results">
			<div class="container-fluid">
				<div class="row-fluid">
					<div class="span3 result-bucket">
						<h4>#$.slatwall.rbKey('entity.product_plural')#</h4>
						<ul class="nav" id="golbalsr-product">
						</ul>
					</div>
					<div class="span3 result-bucket">
						<h4>#$.slatwall.rbKey('entity.productType_plural')#</h4>
						<ul class="nav" id="golbalsr-productType">
						</ul>
					</div>
					<div class="span3  result-bucket">
						<h4>#$.slatwall.rbKey('entity.brand_plural')#</h4>
						<ul class="nav" id="golbalsr-brand">
						</ul>
					</div>
					<div class="span3 result-bucket">
						<h4>#$.slatwall.rbKey('entity.promotion_plural')#</h4>
						<ul class="nav" id="golbalsr-promotion">
						</ul>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span3 result-bucket">
						<h4>#$.slatwall.rbKey('entity.order_plural')#</h4>
						<ul class="nav" id="golbalsr-order">
						</ul>
					</div>
					<div class="span3 result-bucket">
						<h4>#$.slatwall.rbKey('entity.account_plural')#</h4>
						<ul class="nav" id="golbalsr-account">
						</ul>
					</div>
					<div class="span3 result-bucket">
						<h4>#$.slatwall.rbKey('entity.vendorOrder_plural')#</h4>
						<ul class="nav" id="golbalsr-vendorOrder">
						</ul>
					</div>
					<div class="span3 result-bucket">
						<h4>#$.slatwall.rbKey('entity.vendor_plural')#</h4>
						<ul class="nav" id="golbalsr-vendor">
						</ul>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span12">
						<a class="close search-close"><span class="text">Close</span> &times;</a>
					</div>
				</div>
			</div>
		</div>
		<div class="container-fluid">
			<div class="row-fluid">
				<div class="span12">
					#body#
				</div>
			</div>
		</div>
		<div id="adminModal" class="modal fade"></div>
		<div id="adminDisabled" class="modal">
			<div class="modal-header"><a class="close" data-dismiss="modal">&times;</a><h3>#request.slatwallScope.rbKey('define.disabled')#</h3></div>
			<div class="modal-body"></div>
			<div class="modal-footer">
				<a href="##" class="btn btn-inverse" data-dismiss="modal"><i class="icon-ok icon-white"></i> #request.slatwallScope.rbKey('define.ok')#</a>
			</div>
		</div>
		<div id="adminConfirm" class="modal">
			<div class="modal-header"><a class="close" data-dismiss="modal">&times;</a><h3>#request.slatwallScope.rbKey('define.confirm')#</h3></div>
			<div class="modal-body"></div>
			<div class="modal-footer">
				<a href="##" class="btn btn-inverse" data-dismiss="modal"><i class="icon-remove icon-white"></i> #request.slatwallScope.rbKey('define.no')#</a>
				<a href="##" class="btn btn-primary"><i class="icon-ok icon-white"></i> #request.slatwallScope.rbKey('define.yes')#</a>
			</div>
		</div>
		
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-ui-1.8.20.custom.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-ui-timepicker-addon-0.9.9.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-validate-1.9.0.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-hashchange-1.3.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-typewatch-2.0.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/global.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/ckeditor/ckeditor.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/ckeditor/adapters/jquery.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/ckfinder/ckfinder.js"></script>
	</body>
</html>
</cfoutput>
