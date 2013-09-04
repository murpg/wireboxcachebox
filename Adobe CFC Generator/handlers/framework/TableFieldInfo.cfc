<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->

<cfcomponent name="TableFiledInfo" output="false" >

	<cfset this.name = "">
	<cfset this.type = "">
	<cfset this.length = "">
	<cfset this.cfType = "">
	<cfset this.cfSQLType = "">
	<cfset this.javaType = "">
	<cfset this.primaryKey = false>
	<cfset this.nullAllowed = true>
	
	<cffunction name="setName" output="false">
		<cfargument name="name">
		
		<cfset this.name = arguments.name>
	</cffunction>
	
	<cffunction name="getName" output="false">
		<cfreturn this.name>
	</cffunction>
	
	<cffunction name="setType" output="false">
		<cfargument name="type">
		
		<cfset this.type = arguments.type>
    </cffunction>
    
	<cffunction name="getType" output="false">
		<cfreturn this.type>
	</cffunction>
	
	<cffunction name="setLength" output="false">
		<cfargument name="length">
		
		<cfset this.length = arguments.length>
	</cffunction>
	
	<cffunction name="getLength" output="false">
		<cfreturn this.length>
	</cffunction>
	
	<cffunction name="setCFType" output="false">
		<cfargument name="cfType">
		
		<cfset this.cfType = arguments.cfType>
	</cffunction>
	
	<cffunction name="getCFType" output="false">
		<cfreturn this.cfType>
	</cffunction>
	
	<cffunction name="setCFSQLType" output="false">
		<cfargument name="cfSQLType">
		
		<cfset this.cfSQLType = arguments.cfSQLType>
	</cffunction>
	
	<cffunction name="getCFSQLType" output="false">
		<cfreturn this.cfSQLType>
	</cffunction>

	<cffunction name="setJavaType" output="false">
		<cfargument name="javaType" required="true" >
		
		<cfset this.javaType = arguments.javaType>
	</cffunction>
	
	<cffunction name="getJavaType" output="false">
		<cfreturn this.javaType>
	</cffunction>
	
	<cffunction name="isPrimaryKey" returntype="boolean" output="false">
		<cfreturn this.primaryKey>
	</cffunction>
	
	<cffunction name="setPrimaryKey" output="false">
		<cfargument name="primaryKey" required="true" >
		<cfset this.primaryKey = arguments.primaryKey>
	</cffunction>
	
	<cffunction name="isNullAllowed" returntype="boolean" output="false">
		<cfreturn this.nullAllowed>
	</cffunction>
	
	<cffunction name="setNullAllowed" output="false">
		<cfargument name="allowed" required="true">
		<cfset this.nullAllowed = arguments.allowed>
	</cffunction>
	
	<cffunction name="set" output="false">
		<cfargument name="name" required="true" >
		<cfargument name="type" required="true" >
		<cfargument name="length" required="true" >
		<cfargument name="cfType" required="false" >
		<cfargument name="cfSQLType" required="false" >
		<cfargument name="javaType" required="false" >
		<cfargument name="primaryKey" required="false">
		<cfargument name="nullAllowed" required="false" >
		
		
		<cfset setName(arguments.name)>
		<cfset setType(arguments.type)>
		<cfset setLength(arguments.length)>
		<cfif isDefined("arguments.cfType")>
			<cfset setCFType(arguments.cfType)>
		</cfif>
		<cfif isDefined("arguments.cfSQLType")>
			<cfset setCFSQLType(arguments.cfSQLType)>
		</cfif>
		<cfif isdefined("arguments.javaType")>
			<cfset this.javaType = arguments.javaType>
		</cfif>
		<cfif isdefined("arguments.primaryKey")>
			<cfset this.primaryKey = arguments.primaryKey>
		</cfif>
		<cfif isdefined("arguments.nullAllowed")>
			<cfset this.nullAllowed = arguments.nullAllowed>
		</cfif>
	</cffunction>
	
</cfcomponent>