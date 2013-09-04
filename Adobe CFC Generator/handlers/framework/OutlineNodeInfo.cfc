<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->

<cfcomponent name="OutlineNodeInfo" output="false" >

	<cfset this.nodeType = "">
	<cfset this.functionInfo = "">


	<cffunction name="getNodeType" output="false">
		<cfreturn this.nodeType>
	</cffunction>
	
	<cffunction name="setNodeType" output="false">
		<cfargument name="type" required="true" >
		
		<cfset this.nodeType = arguments.type>
	</cffunction>
	

 	<cffunction name="getFunctionInfo" returntype="FunctionInfo" output="false">
		<cfreturn this.functionInfo>
	</cffunction>
	
	<cffunction name="setFunctionInfo" output="false">
		<cfargument name="info" type="FunctionInfo" required="true" >
		
		<cfset this.functionInfo = arguments.info>
	</cffunction>
	
	<cffunction name="isFunctionNode" returntype="boolean" output="false">
		<cfif getNodeType() eq "function" and getFunctionInfo() neq "">
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>

</cfcomponent>