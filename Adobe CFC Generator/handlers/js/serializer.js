/*
ADOBE SYSTEMS INCORPORATED
 Copyright 2011 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
*/

//Author : Ram Kulkarni

function dbTableDTO ()
{
	this.name;
	this.cfcName;
	this.cols = new Array();
	this.relations = new Array();
}

function dbColumnDTO ()
{
	this.name;
	this.propertyName;
	this.propertyType;
	this.isPrimaryKey;
	this.isSelected;
}

function dbRelationDTO ()
{
	this.srcRelName;
	this.srcRelMultiplicity;
	this.targetRelName;
	this.targetRelMultiplicity;
	this.srcRelEnabled;
	this.targetRelEnabled;
	
	this.linkTable;
	this.srcTable;
	this.srcCol;
	this.targetTable;
	this.targetCol;
	this.linkTableConditions = new Array();
}

function serializeDBTablesToJSON (dbTableArray)
{
	var tableDTOArray = new Array();
	$.each(dbTableArray, function (index, table){
		var dtoTable = createTableDTO(table);
		if (dtoTable != undefined)
			tableDTOArray.push(dtoTable);
	});
	
	return JSON.stringify(tableDTOArray);
}

function createTableDTO (dbTable)
{
	var dbTabDTO = new dbTableDTO();
	dbTabDTO.name = dbTable.name;
	dbTabDTO.cfcName = dbTable.cfcName;
	
	var atLeastOneSelected = false;
	
	$(dbTable.cols).each(function(index, col){
		if (col.isSelected == true) {
			dbTabDTO.cols.push(createColumnDTO(col));
			atLeastOneSelected = true;
		}
	});
	
	if (atLeastOneSelected == false)
		return null;
	
	$(dbTable.relations).each(function (index, rel){
		dbTabDTO.relations.push(createRelationDTO(rel));
	});
	
	return dbTabDTO;
}

function createColumnDTO (col)
{
	var dbColDTO = new  dbColumnDTO();
	dbColDTO.name = col.name;
	dbColDTO.propertyName = col.propertyName;
	dbColDTO.propertyType = col.propertyType;
	dbColDTO.isPrimaryKey = col.isPrimaryKey;
	dbColDTO.isSelected = col.isSelected;
	
	return dbColDTO;
}

function createRelationDTO (rel)
{
	var relDTO = new dbRelationDTO();
	
	relDTO.srcRelName = rel.srcRelName;
	relDTO.srcRelMultiplicity = rel.srclMultiplicity;
	relDTO.targetRelName = rel.targetRelName;
	relDTO.targetRelMultiplicity = rel.targetMultiplicity;
	relDTO.srcRelEnabled = rel.srcRelEnabled;
	relDTO.targetRelEnabled = rel.targetRelEnabled;
	
	if (rel.linkTable != undefined && rel.linkTable != '')
		relDTO.linkTable = rel.linkTable.name;
	else
		relDTO.linkTable = "";
		
	relDTO.srcTable = rel.srcTable.name;
	relDTO.srcCol = rel.srcTableCol.name;
	relDTO.targetTable = rel.targetTable.name;
	relDTO.targetCol = rel.targetTableCol.name;
	
	$(rel.linkTableConditions).each(function(index, cond){
		var condStr = cond.table.name + "." + cond.col.name;
		relDTO.linkTableConditions.push(condStr);
	});
	
	return relDTO;
}