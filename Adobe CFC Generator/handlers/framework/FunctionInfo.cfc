<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->

<cfcomponent name="FunctionInfo" output="false" >

	<cfset this.functionName = "">
	<cfset this.returnType = "">
	<cfset this.arguments = Arraynew(1)>
	
	<cffunction name="setFunctionName" output="false">
		<cfargument name="name">
		
		<cfset this.functionName = arguments.name>
	</cffunction>
	
	<cffunction name="getFunctionName" output="false">
		<cfreturn this.functionName>
	</cffunction>
	
	<cffunction name="getReturnType" output="false">
		<cfreturn this.returnType>
	</cffunction>
	
	<cffunction name="setReturnType" output="false">
		<cfargument name="type">
		
		<cfset this.returnType = arguments.type>
	</cffunction>
	
	<cffunction name="addArgument" output="false">
		<cfargument name="arg" type="ArgumentInfo" required="true" >
		
		<cfset ArrayAppend(this.arguments, arguments.arg)>
	</cffunction>
	
	<cffunction name="getArguments" returntype="Array" output="false">
		<cfreturn this.arguments>
	</cffunction>
	
</cfcomponent>