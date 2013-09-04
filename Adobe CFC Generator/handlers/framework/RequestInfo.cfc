<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->

<cfcomponent name="RequestInfo" output="false" >

	<cfset this.userDefinedFields = Arraynew(1)>
	
	<cfset this.projectInfo = "">
	
	<cfset this.rdsInfo = "">
	
	<cfset this.outlineInfo = "">
	
	<cfset this.eventInfo = "">
	
	<cfset this.editorInfo = "">
	
	<cffunction name="addUserDefinedFiled" output="false">
		<cfargument name="property" type="Property">
		<cfset ArrayAppend(this.userDefinedFields,arguments.property)>
    </cffunction> 
	
	<cffunction name="getUserDefinedFileds" output="false">
		<cfreturn this.userDefinedFields>
    </cffunction>
	
	<cffunction name="projectInfoExists" returntype="boolean" output="false">
		<cfif this.projectInfo eq "">
			<cfreturn false>
		</cfif>
		<cfreturn true>
    </cffunction>
	
	<cffunction name="getProjectInfo" returntype="ProjectInfo" output="false">
		<cfreturn this.projectInfo>
    </cffunction>
	
	<cffunction name="setProjectInfo" output="false">
		<cfargument name="info" type="ProjectInfo" required="true" >
		
		<cfset this.projectInfo = arguments.info>
    </cffunction>
	
	<cffunction name="setRDSInfo" output="false">
		<cfargument name="rdsInfo" required="true" type="RDSInfo">
		
		<cfset this.rdsInfo = arguments.rdsInfo>
	</cffunction>
	
	
	<cffunction name="getRDSInfo" returntype="RDSInfo" output="false">
		<cfreturn this.rdsInfo>
	</cffunction>
	
	<cffunction name="setOutlineInfo" output="false">
		<cfargument name="info" type="OutlineInfo" required="true" >
		
		<cfset this.outlineInfo = arguments.info>  
	</cffunction>
	
	<cffunction name="getOutlineInfo" returntype="OutlineInfo" output="false">
		<cfreturn this.outlineInfo>
	</cffunction>
	
	<cffunction name="setEventInfo" output="false">
		<cfargument name="info" type="EventInfo" required="true">
		
		<cfset this.eventInfo = arguments.info>
	</cffunction>
	
	<cffunction name="getEventInfo" returntype="EventInfo" output="false">
		<cfreturn this.eventInfo>
	</cffunction>
	
	
	<cffunction name="hasProjectInfo" returntype="boolean" output="false">
		<cfif this.projectInfo eq "">
			<cfreturn false>
		</cfif>
		<cfreturn true>
    </cffunction>
	
	<cffunction name="hasRDSInfo" returntype="boolean" output="false">
		<cfif this.rdsInfo eq "">
			<cfreturn false>
		</cfif>
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="hasOutlineInfo" returntype="boolean" output="false">
		<cfif this.outlineInfo eq "">
			<cfreturn flase>
		</cfif>
		<cfreturn true>
	</cffunction> 
	
	<cffunction name="hasEventInfo" returntype="boolean" output="false">
		<cfif this.eventInfo eq "">
			<cfreturn false>
		</cfif>
		<cfreturn true>
	</cffunction> 

	<cffunction name="setEditorInfo" output="false">
		<cfargument name="editorInfo" required="true" type="EditorInfo" >
		
		<cfset this.editorInfo = arguments.editorInfo>
	</cffunction>
	
	
	<cffunction name="getEditorInfo" returntype="EditorInfo" output="false">
		<cfreturn this.editorInfo>
	</cffunction>

</cfcomponent>