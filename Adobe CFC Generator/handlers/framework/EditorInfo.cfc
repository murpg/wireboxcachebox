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
	<cfset this.fileName = "">
	<cfset this.filePath = "">
	<cfset this.projectRelativeLocation = "">
	<cfset this.projectName = "">
	<cfset this.projectLocation = "">
	<cfset this.selectionStartLine = 0>
	<cfset this.selectionEndLine = 0>
	<cfset this.selectionStartColumn = 0>
	<cfset this.selectionEndColumn = 0>
	<cfset this.selectedText = "">
	
	
	<cffunction name="getFileName" output="false">
		<cfreturn this.fileName>
	</cffunction>
	
	<cffunction name="setFileName" output="false">
		<cfargument name="fileName" required="true" >
		<cfset this.fileName = arguments.fileName>
	</cffunction>


	<cffunction name="getFilePath" output="false">
		<cfreturn this.filePath>
	</cffunction>
	
	<cffunction name="setFilePath" output="false">
		<cfargument name="filePath" required="true" >
		<cfset this.filePath = arguments.filePath>
	</cffunction>


	<cffunction name="getProjectRelativeLocation" output="false">
		<cfreturn this.projectRelativeLocation>
	</cffunction>
	
	<cffunction name="setProjectRelativeLocation" output="false">
		<cfargument name="projectRelativeLocation" required="true" >
		<cfset this.projectRelativeLocation = arguments.projectRelativeLocation>
	</cffunction>


	<cffunction name="getProjectName" output="false">
		<cfreturn this.projectName>
	</cffunction>
	
	<cffunction name="setProjectName" output="false">
		<cfargument name="projectName" required="true" >
		<cfset this.projectName = arguments.projectName>
	</cffunction>


	<cffunction name="getProjectLocation" output="false">
		<cfreturn this.projectLocation>
	</cffunction>
	
	<cffunction name="setProjectLocation" output="false">
		<cfargument name="projectLocation" required="true" >
		<cfset this.projectLocation = arguments.projectLocation>
	</cffunction>

	<cffunction name="getSelectionStartLine" output="false">
		<cfreturn this.selectionStartLine>
	</cffunction>
	
	<cffunction name="setSelectionStartLine" output="false">
		<cfargument name="selectionStartLine" required="true" >
		<cfset this.selectionStartLine = arguments.selectionStartLine>
	</cffunction>

	<cffunction name="getSelectionEndLine" output="false">
		<cfreturn this.selectionEndLine>
	</cffunction>
	
	<cffunction name="setSelectionEndLine" output="false">
		<cfargument name="selectionEndLine" required="true" >
		<cfset this.selectionEndLine = arguments.selectionEndLine>
	</cffunction>

	<cffunction name="getSelectionStartColumn" output="false">
		<cfreturn this.selectionStartColumn>
	</cffunction>
	
	<cffunction name="setSelectionStartColumn" output="false">
		<cfargument name="selectionStartColumn" required="true" >
		<cfset this.selectionStartColumn = arguments.selectionStartColumn>
	</cffunction>

	<cffunction name="getSelectionEndColumn" output="false">
		<cfreturn this.selectionEndColumn>
	</cffunction>
	
	<cffunction name="setSelectionEndColumn" output="false">
		<cfargument name="selectionEndColumn" required="true" >
		<cfset this.selectionEndColumn = arguments.selectionEndColumn>
	</cffunction>

	<cffunction name="getSelectedText" output="false">
		<cfreturn this.selectedText>
	</cffunction>
	
	<cffunction name="setSelectedText" output="false">
		<cfargument name="selectedText" required="true" >
		<cfset this.selectedText = arguments.selectedText>
	</cffunction>
	
</cfcomponent>