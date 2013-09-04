<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
--->
<cfcomponent>
	<cfset this.relationName = "">
	<cfset this.targetTable = "">
	<cfset this.multiplicity = ""> 	
	<cfset this.linkTable = "">
	<cfset this.joinConditions = []>
	<!---
		fkcolSideFor1to1Relation and mappedby are used to generate code for 1-1 mapping. 1 is default value,
		 2 means fkcolumn side and 3 means mappedby side. 
	--->
	<cfset variables.fkcolSideFor1to1Relation = 1>
	<cfset variables.mappedby = "">
	
	<cffunction name="getJoins" output="false">
		<cfreturn this.joinConditions>
	</cffunction>
	
	<cffunction name="addJoin" output="false">
		<cfargument name="joinCondition">
		<cfset ArrayAppend(this.joinConditions,joinCondition)>
	</cffunction>

	<cffunction name="setJoins" output="false">
		<cfargument name="joinConditions">
		<cfset this.joinConditions = joinConditions>
	</cffunction>
		
	<cffunction name="setrelationName" output="false">
		<cfargument name="name">		
		<cfset this.relationName = arguments.name>
	</cffunction>
	
	<cffunction name="getrelationName" output="false">
		<cfreturn this.relationName>
	</cffunction>
	
	<cffunction name="getLinkTable" output="false">
		<cfreturn this.linkTable>
	</cffunction>
	
	<cffunction name="setLinkTable" output="false">
		<cfargument name="linkTable">		
		<cfset this.linkTable = arguments.linkTable>
	</cffunction>	
	
	<cffunction name="settargetTable" output="false">
		<cfargument name="name">		
		<cfset this.targetTable = arguments.name>
	</cffunction>
	
	<cffunction name="gettargetTable" output="false">
		<cfreturn this.targetTable>
	</cffunction>
	
	<cffunction name="setmultiplicity" output="false">
		<cfargument name="name">		
		<cfset this.multiplicity = arguments.name>
	</cffunction>
	
	<cffunction name="getmultiplicity" output="false">
		<cfreturn this.multiplicity>
	</cffunction>
	
	<cffunction name="setresolved" output="false">
		<cfargument name="name">		
		<cfset this.resolved = arguments.name>
	</cffunction>
	
	<cffunction name="getresolved" output="false">
		<cfreturn this.resolved>
	</cffunction>

	<cffunction name="getFKcolSideFor1to1Relation" output="false">
		<cfreturn variables.fkcolSideFor1to1Relation>
	</cffunction>
	
	<cffunction name="setFKcolSideFor1to1Relation" output="false">
		<cfargument name="fkcol" required="true">		
		<cfset variables.fkcolSideFor1to1Relation = arguments.fkcol>
	</cffunction>
	
	<cffunction name="getMappedby" output="false">
		<cfreturn variables.mappedby>
	</cffunction>
	
	<cffunction name="setMappedby" output="false">
		<cfargument name="mappedby" required="true">		
		<cfset variables.mappedby = arguments.mappedby>
	</cffunction>	
</cfcomponent>