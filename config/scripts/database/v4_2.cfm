<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

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

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

--->

<cfset local.scriptHasErrors = false />

<cftry>

	<cfquery name="local.updateautofulfilltrue" dbtype="query">
		update SwFulfillmentMethod set autoFulfillFlag=1 where fulfillmentMethodType=<cfqueryparam cfsqltype="cf_sql_varchar" value="email"> or fulfillmentMethodType=<cfqueryparam cfsqltype="cf_sql_varchar" value="auto"> and autoFulfillFlag is null
	</cfquery>

	<cfquery name="local.updateautofulfillfalse" dbtype="query">
		update SwFulfillmentMethod set autoFulfillFlag=0 where fulfillmentMethodType!=<cfqueryparam cfsqltype="cf_sql_varchar" value="email"> and fulfillmentMethodType!=<cfqueryparam cfsqltype="cf_sql_varchar" value="auto"> and autoFulfillFlag is null
	</cfquery>

	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update autofulfillflag for fulfillment methods">
		<cfset local.scriptHasErrors = true />
	</cfcatch>


</cftry>

<cftry>

	<cfquery name="local.updatereporttype" dbtype="query">
		update SwReport set reportType=<cfqueryparam cfsqltype="cf_sql_varchar" value="line"> where reportType is null
	</cfquery>

	<cfquery name="local.updatereportlimitresults" dbtype="query">
		update SwReport set limitResults=5 where limitResults is null
	</cfquery>

	<cfquery name="local.updatereportlimitresults" dbtype="query">
		update SwReport set showReport=1 where showReport is null
	</cfquery>

	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update Report">
		<cfset local.scriptHasErrors = true />
	</cfcatch>

</cftry>


<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script v4_2 had errors when running">
	<cfthrow detail="Part of Script v4_1 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script v4_2 has run with no errors">
</cfif>