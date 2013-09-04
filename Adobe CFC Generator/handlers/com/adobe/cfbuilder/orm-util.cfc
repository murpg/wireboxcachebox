<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->
<cfcomponent hint="Utility Functions For Extending Bolt" output="false">

	<cffunction name="writeTemplate" returntype="void" access="public">
		<cfargument name="destination" type="string" required="true" />
		<cfargument name="template" type="string" required="true" />
		<cfargument name="tableinfo" required="false" />
		<cfset var file = "" />
		<cfset variables.util = this>
		<cflog file="bolt" text="writing template... #ARGUMENTS.template# destination:#ARGUMENTS.destination#" />
		
		<!---- generate file ---->
		<cfsavecontent variable="file"><cfinclude template="templates/#ARGUMENTS.template#" /></cfsavecontent>
		<!---- parse cf prefix ---->
		<cfset file = reReplaceNoCase(file, ':cf', 'cf', 'all') />
		<cfset file = reReplaceNoCase(file, ':/cf', '/cf', 'all') />
		<!---- convert comments ---->
		<cfset file = reReplaceNoCase(file, '<!--', '<!----', 'all') />
		<cfset file = reReplaceNoCase(file, '-->', '---->', 'all') />
		<!---- remove double linebreaks ---->
		<cfset file = reReplaceNoCase(file, chr(10) & chr(10), chr(10), 'all') />
		<!---- write to disk --->
		<cffile action="write" output="#file#" file="#ARGUMENTS.destination#" fixnewline="yes" />
		<cflog file="bolt" text="file written... #ARGUMENTS.destination#" />
		<!---- return success ---->
		<cfreturn />
	</cffunction>

	<cffunction name="getRelationMultiplicity" returntype="String">
		<cfargument name="multiplicity" required="true">
		<cfswitch expression="#multiplicity#">
			<cfcase value="1-1">
				<cfreturn "one-to-one">
	        </cfcase>
			<cfcase value="1-n">
				<cfreturn "one-to-many">
            </cfcase>
			<cfcase value="n-1">
				<cfreturn "many-to-one">
			</cfcase>
			<cfcase value="m-n">
				<cfreturn "many-to-many">
			</cfcase>			
			<cfdefaultcase>
				<cfreturn "">
            </cfdefaultcase>
	    </cfswitch>
    </cffunction>
	
	<cfscript>
		function tab(num)
		{
			var output = '';
			var i = 0;
			for(i = 1; i LTE ARGUMENTS.num; i++)
			{
				output = output & chr(9);
			}
			return output;
		}
		
		function linebreak(num)
		{
			var output = '';
			var i = 0;
			for(i = 1; i LTE ARGUMENTS.num; i++)
			{
				output = output & chr(10);
			}
			return output;
		}
		
		function tCase(arg)
		{
			ARGUMENTS.arg = ucase(ARGUMENTS.arg);
			return reReplace(ARGUMENTS.arg,"([[:upper:]])([[:upper:]]*)","\1\L\2\E","all");
		}

	</cfscript>

</cfcomponent>