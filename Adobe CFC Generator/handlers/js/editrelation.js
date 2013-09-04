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

_editRelDlg = null;
_relDlgClass = "relationDlg";

_connectorUIObj = null;
_dbRelationObj = null;
_dummyLinkTableName = "__dummy__";
_newLinkConditionRow = "newLinkCondRow";
_linkTableCondLH = "linkTableCondLH";
_linkTableCondRH = "linkTableCondRH";
_linkTableCondDel = "linkTableCondDel";

_selectedColDataObj = "selectedColData";

_linkCondSelCtrl = null;

function createRelationDialog(conectorUIArg, x, y){
	_connectorUIObj = conectorUIArg;
	_dbRelationObj = conectorUIArg.dbTableRelation; 
	
	if (_editRelDlg == undefined)
	{
		var pageContent = $.get("editrelation.html", onLoadPageContent);
		
		var relName = "";
		if (_dbRelationObj.name != undefined)
			relName = _dbRelationObj.name;
			
		var dlgDiv = "<div class='" + _relDlgClass + "'>" +
		"</div>";
		$("body").append(dlgDiv);
		_editRelDlg  = $("." + _relDlgClass).dialog({
			dialogClass : "relEditDlg",
			autoOpen : false,
			height : 450,
			width : 550,
			modal : true,
			buttons : {
				"Save" : onSaveRelationship,
				"Cancel" : onCancelRelationship,
			}
		});
	}
	
	initDBRelationEditorPage();
	
	$(_editRelDlg).dialog("option", "position", [x, y]);
	$(_editRelDlg).dialog("open");	
}

function onLoadPageContent (data)
{
	$(_editRelDlg).html(data);
	initDBRelationEditorPage();
	
	$("select[name|='linkTableList']").change(onLinkTableChange);
	$("input#targetRelCheckBox").click(onTargetRelChkClicked);
	$("input#srcRelCheckBox").click(onSrcRelChkClicked);
	
	$("select[name|='srcMultiplicityList']").change(onSrcMultiplicitychanged);
	$("select[name|='targetMultiplicityList']").change(onTargetMultiplicitychanged);
}

function initDBRelationEditorPage()
{
	if (_dbRelationObj.srcRelName != undefined)
		$("input[name|='srcRelName']").val(_dbRelationObj.srcRelName);

	if (_dbRelationObj.targetRelName != undefined)
		$("input[name|='targetRelationName']").val(_dbRelationObj.targetRelName);
		
	if (_dbRelationObj.srclMultiplicity != undefined) {
		var optCtrl = $("select[name|='srcMultiplicityList'] option[value|='" + _dbRelationObj.srclMultiplicity + "']");
		if (optCtrl.length == 1)
			optCtrl.attr("selected", "selected");
	}

	if (_dbRelationObj.targetMultiplicity != undefined) {
		var optCtrl = $("select[name|='targetMultiplicityList'] option[value|='" + _dbRelationObj.targetMultiplicity + "']");
		if (optCtrl.length == 1)
			optCtrl.attr("selected", "selected");
	}
	
	$("legend#srcRelLegend").html(_dbRelationObj.srcTable.name + " Relationship");
	$("legend#targetRelLegend").html(_dbRelationObj.targetTable.name + " Relationship");

	if (_dbRelationObj.srcRelEnabled == true)
		$("input#srcRelCheckBox").attr("checked", "checked");
	else
		$("input#srcRelCheckBox").removeAttr("checked");

	if (_dbRelationObj.targetRelEnabled == true)
		$("input#targetRelCheckBox").attr("checked", "checked");
	else
		$("input#targetRelCheckBox").removeAttr("checked");
		
	selectSrcMutiplicity(_dbRelationObj.srclMultiplicity);
	selectTargetMutiplicity(_dbRelationObj.targetMultiplicity);

	updateSrcRelGroup();
	updateTargetRelGroup();	
		
	_editRelDlg.dialog("option", {'title' : "Edit Relationship " + _dbRelationObj.name});
	
	var linkTableListCtrl = $("select[name|='linkTableList']").empty();
	
	populateLinkTables(linkTableListCtrl);	
	populateLinkCondTable();

}

function populateLinkTables (linkTableCtrl)
{
	var srcTableName = _dbRelationObj.srcTable.name;
	var targetTableName = _dbRelationObj.targetTable.name;

	linkTableCtrl.append("<option value='" + _dummyLinkTableName + "'></option>");
	
	var linkTable = "";
	if (_dbRelationObj.linkTable != undefined)
		linkTable = _dbRelationObj.linkTable.name;
		
	$.each(_tableUIs, function(index, tableUI){
		if (tableUI.dbTable.name != srcTableName && tableUI.dbTable.name != targetTableName)
		{
			var optCtrlStr = "<option ";
			if (tableUI.dbTable.name == linkTable)
				optCtrlStr += "selected='selected'";
						
			optCtrlStr += ">" + tableUI.dbTable.name + "</option>";
			
			var optCtrl = $(optCtrlStr).appendTo( linkTableCtrl);
			optCtrl.data(_selectedColDataObj,tableUI.dbTable);
		}	
	});
}

function onLinkTableChange(event)
{
	//remove existing rows in the table
	$("table#linkTableDtlTable tr:not(.linkTableHeader)").remove();
	
	//add empty row	
	addNewLinkConditionRow();
}

function addNewLinkConditionRow(lhTableCol, rhTableCol)
{
	var linkTable = $("table#linkTableDtlTable");
	
	var trClass;
	var delColCont = "X";
	var lhCond, rhCond;
	
	if (lhTableCol == undefined && rhTableCol == undefined) 
	{
		trClass = _newLinkConditionRow;
		lhCond = rhCond = "";
	}
	
	if (lhTableCol != undefined)
		lhCond = lhTableCol.table.name + "." + lhTableCol.col.name;
	else
		lhCond = "";
	if (rhTableCol != undefined)
		rhCond = rhTableCol.table.name + "." + rhTableCol.col.name;
	else
		rhCond = "";
		
	var trCont = "<tr";
	if (trClass != undefined)
		trCont += " class='" + trClass + "'";
	trCont += "></tr>";
		
	var newRow = $(trCont).appendTo(linkTable);
	var lhCondTd = $("<td class='" + _linkTableCondLH + " defaultCursor'>" + lhCond + "</td>").appendTo(newRow);
	var rhCondTd = $("<td class='" + _linkTableCondRH + " defaultCursor'>" + rhCond + "</td>").appendTo(newRow);
	var delCondTd = $("<td class='" + _linkTableCondDel + " defaultCursor'>" + delColCont + "</td>").appendTo(newRow);
	
	lhCondTd.click(onLHLinkCondClicked);
	rhCondTd.click(onRHLinkCondClicked);
	delCondTd.click(onDelLinkCondClick);
	
	if (lhTableCol != undefined)
		lhCondTd.data(_selectedColDataObj,lhTableCol);
	if (rhTableCol != undefined)
		rhCondTd.data(_selectedColDataObj,rhTableCol);
}

function onSaveRelationship()
{
	//check link table relationship conditions are complete
	var newCond = $("table#linkTableDtlTable tr.newLinkCondRow");
	if (newCond.length > 0)
	{
		var lhCond = $(newCond).children("td."+_linkTableCondLH);
		var rhCond =$(newCond).children("td."+_linkTableCondRH);
		if (lhCond.html() != "" && rhCond != "") {
			showMessage("Incomplete link table condition entered", "Error");
			return;
		}
	}	

	if ($("table#linkTableDtlTable tr:not(.linkTableHeader)").length < 2)
	{
		showMessage("At least one join condition must be specified", "Error");
		return;		
	}
		
	//_dbRelationObj.name = $("table#relDetailTable input[name|='relName']").val();
	
	srcRelEnabled = $("input#srcRelCheckBox").attr("checked") != undefined;
	targetRelEnabled = $("input#targetRelCheckBox").attr("checked") != undefined;
	
	if (srcRelEnabled == false && targetRelEnabled == false)
	{
		showMessage("At least one table relationship should be defined", "Error");
		return;
	}
	
	_dbRelationObj.srcRelEnabled = srcRelEnabled;
	_dbRelationObj.targetRelEnabled = targetRelEnabled;
	
	_dbRelationObj.srcRelName = $("input[name|='srcRelName']").val();
	_dbRelationObj.targetRelName = $("input[name|='targetRelationName']").val();
	
	_dbRelationObj.srclMultiplicity = $("select[name|='srcMultiplicityList']").val();
	_dbRelationObj.targetMultiplicity = $("select[name|='targetMultiplicityList']").val();
	
	var linkTableCtrl = $("select[name|=linkTableList]");
	var linkTableName = $(linkTableCtrl).val();
	if (linkTableName != undefined && linkTableName != "")
	{
		_dbRelationObj.linkTable = linkTableCtrl.children("option[value|='" + linkTableName + "']").data(_selectedColDataObj);
	}
	
	//empty condtions array
	_dbRelationObj.linkTableConditions.length = 0;
	
	$("table#linkTableDtlTable tr:not(.linkTableHeader)").each(function(){
		if ($(this).hasClass(_newLinkConditionRow))
			return;
		var lhTableCol = $(this).children("td."+_linkTableCondLH).data(_selectedColDataObj);
		var rhTableCol = $(this).children("td."+_linkTableCondRH).data(_selectedColDataObj);
		_dbRelationObj.linkTableConditions.push(lhTableCol);
		_dbRelationObj.linkTableConditions.push(rhTableCol);
	});
	
	closeRelationDlg();
}

function onCancelRelationship(){
	closeRelationDlg();
}

function closeRelationDlg() {
	$(_editRelDlg).dialog("close");	
}

function onLHLinkCondClicked()
{
	onLinkCondClicked(true, $(this));
	
}

function onRHLinkCondClicked ()
{
	onLinkCondClicked(false, $(this));
}

function onLinkCondClicked(isLH, tdCtrl)
{
	createLinkConditionSelCtrl();

	_linkCondSelCtrl.data(_selectedColDataObj, tdCtrl);
	 
	 if (isLH)
	 	populateLHLinkTableCondList();
	else
	 	populateRHLinkTableCondList();
	 
	_linkCondSelCtrl.show(); 
	_linkCondSelCtrl.focus();
	_linkCondSelCtrl.css({"zindex" : 0, "position" : "absolute"});
	_linkCondSelCtrl.offset({left : tdCtrl.offset().left, top : tdCtrl.offset().top});
	_linkCondSelCtrl.width(tdCtrl.width());
	_linkCondSelCtrl.height( tdCtrl.height());
}

function onDelLinkCondClick()
{
	var trCtrl = $(this).parent();
	
	var lhCond = $(trCtrl).children("td."+_linkTableCondLH);
	var rhCond =$(trCtrl).children("td."+_linkTableCondRH);
	
	if (lhCond.html() != "" && rhCond.html() != "") {
		trCtrl.remove();
	}
	else 
		if (trCtrl.hasClass(_newLinkConditionRow)) {
			lhCond.html("");
			rhCond.html("");
		}
}

function populateLHLinkTableCondList()
{
	populateLinkTableCondList(_dbRelationObj.srcTable);
}

function populateRHLinkTableCondList()
{
	populateLinkTableCondList(_dbRelationObj.targetTable);
}

function populateLinkCondTable()
{
	//first remove all rows
	$("table#linkTableDtlTable tr:not(.linkTableHeader)").remove();
	
	for (var i = 0; i < _dbRelationObj.linkTableConditions.length; i += 2)
	{
		addNewLinkConditionRow(_dbRelationObj.linkTableConditions[i],
			_dbRelationObj.linkTableConditions[i+1]);
	}
	
	addNewLinkConditionRow();
}

function populateLinkTableCondList (dbTable1Arg)
{
	var linkTableName = $("select[name|='linkTableList']").val();
	
	var linkTable;
	
	if (linkTableName != "") {
		for (var i in _tableUIs) {
			var tableUI = _tableUIs[i];
			if (tableUI.dbTable.name == linkTableName) {
				linkTable = tableUI.dbTable;
				break;
			}
		}
	}

	populateLinkTableCondListHelper(dbTable1Arg);
	if (linkTable != undefined)
		populateLinkTableCondListHelper(linkTable);
}

function populateLinkTableCondListHelper (dbTableArg)
{
	var tdCtrl = _linkCondSelCtrl.data(_selectedColDataObj);
	var tdValue = $(tdCtrl).html();
	
	for (var i in dbTableArg.cols)
	{
		var col = dbTableArg.cols[i];
		var tableCol = new dbTableColPair(dbTableArg, col);
		var value = dbTableArg.name + "." + col.name;
		var optionStr = "<option value='" + value + "' ";
		if (tdValue == value)
			optionStr += "selected='selected'"; 
		optionStr += ">" + value + "</option>";
		var optionCtrl = $(optionStr).appendTo(_linkCondSelCtrl);
		optionCtrl.data(_selectedColDataObj, tableCol);
	}
}

function createLinkConditionSelCtrl()
{
	if (_linkCondSelCtrl != undefined) {
		_linkCondSelCtrl.children().remove();
		return;
	}
	
	_linkCondSelCtrl = $("<select name='condSel'></select>").appendTo("div#joinCondDiv");
	_linkCondSelCtrl.blur(onCondSelLostFocus);
}

function onCondSelLostFocus()
{
	var tdCtrl = _linkCondSelCtrl.data(_selectedColDataObj);
	
	var selectedText = _linkCondSelCtrl.val();
	var optionCtrl = $(_linkCondSelCtrl).children("[value|='" + selectedText + "']");
	tdCtrl.data(_selectedColDataObj,optionCtrl.data(_selectedColDataObj))
	
	var trCtrl = $(tdCtrl).parent();
	tdCtrl.html(selectedText);
	
	var lhCond = $(trCtrl).children("td."+_linkTableCondLH);
	var rhCond =$(trCtrl).children("td."+_linkTableCondRH);
	
	if (lhCond.html() != "" && rhCond.html() != "" ) 
	{
		trCtrl.removeClass(_newLinkConditionRow);
		if ($(trCtrl).parent().children("tr." + _newLinkConditionRow).length == 0)		
			addNewLinkConditionRow();
	}
	
	_linkCondSelCtrl.hide();
}

function onSrcRelChkClicked ()
{
	updateSrcRelGroup();
}

function onTargetRelChkClicked()
{
	updateTargetRelGroup();
}

function updateSrcRelGroup()
{
	if ($("input#srcRelCheckBox").attr("checked") != undefined)
	{
		disableAllChildren($("fieldset#srcRelGroup"), false);
		$("fieldset#srcRelGroup").removeClass("disabledCtrl");
	}
	else
	{
		disableAllChildren($("fieldset#srcRelGroup"), true);
		$("fieldset#srcRelGroup").addClass("disabledCtrl");
	}

}

function updateTargetRelGroup(){
	if ($("input#targetRelCheckBox").attr("checked") != undefined)
	{
		$("input#targetRelCheckBox").attr("checked", "checked");
		disableAllChildren($("fieldset#targetRelGroup"), false);
		$("fieldset#targetRelGroup").removeClass("disabledCtrl");
	}
	else
	{
		disableAllChildren($("fieldset#targetRelGroup"), true);
		$("fieldset#targetRelGroup").addClass("disabledCtrl");
	}
}

function disableAllChildren(ctrl, isDisable)
{
	if (isDisable) 
		$(ctrl).attr("disabled", "disabled");
	else 
		$(ctrl).removeAttr("disabled");
	
	$(ctrl).children().each(function(index, child)
	{
		disableAllChildren(child,isDisable);
	});
}

function onSrcMultiplicitychanged()
{
	var selectedMul = $(this).val();
	selectTargetMutiplicity (getOppMultiplicity(selectedMul));
} 

function selectTargetMutiplicity (valueArg)
{
	$("select[name|='targetMultiplicityList'] option").removeAttr("selected");
	$("select[name|='targetMultiplicityList'] option[value|='" + valueArg + "']").attr("selected", "selected");
}

function onTargetMultiplicitychanged()
{
	var selectedMul = $(this).val();
	selectSrcMutiplicity (getOppMultiplicity(selectedMul));
}

function selectSrcMutiplicity (valueArg)
{
	$("select[name|='srcMultiplicityList'] option").removeAttr("selected");
	$("select[name|='srcMultiplicityList'] option[value|='" + valueArg + "']").attr("selected", "selected");
}

function getOppMultiplicity(mulArg)
{
	switch (mulArg)
	{
		case "1-1":
			return "1-1";
		case "1-n":
			return "n-1";
		case "n-1":
			return "1-n";
		case "m-n":
			return "m-n";
	}
}
