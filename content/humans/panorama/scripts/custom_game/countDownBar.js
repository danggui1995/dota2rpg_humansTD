"use strict"


function startCountDown(data){
	var title = data.title | "no title";
	var time = data.time | 80;

	$('#countDownPanel').styles.visibility == "visible" ;
	addcdb(1,title);
	//updateCountDownBar(title,time);
}

function updateCountDownBar(time,percent){
	if (!Game.IsGamePaused()){
		var countDownBar = $('#countDownBar');
		countDownBar.style.width = percent * ( time-1/time );
		if (percent && percent<=0) {
			interruptCountDown();
		}
	}
	$.Schedule(1,updateCountDownBar,time,percent);
}

function interruptCountDown(){
	$.CancelScheduled(updateCountDownBar);
}

// function addCdb(line,time) {
// 	var cdb = $(line);

// 	if(!cdb||cdb==undefined) return ;

// 	var barBg = $.CreatePanel('Panel', cdb, line+'barBg');
// 	var bar = $.CreatePanel('Panel',barBg,line+'bar');

// 	barBg.AddClass('countDownBarBg');
// 	bar.AddClass('countDownBar');
// }

function addLine(cdbid,subid,text){    
	var cdb = $('#cdb'+cdbid+'#LineContainer');

	if(!cdb||cdb==undefined) return ;

	var line = $.CreatePanel('Panel', cdb, 'cdb'+cdbid+'#Line'+subid);
	line.AddClass('cdbLinePanel');
	lineText = $.CreatePanel('Label', line, 'cdb'+cdbid+'#Line'+subid+'#Text');
	lineText.html = true;
	if (text) {
		lineText.text = " • " + text;
	}
	
	lineText.AddClass('cdbLine');
	
	return line;
}

function addNewCdBar (id,title){

	// if($('#cdb'+id)){
	// 	$('#cdb'+id).RemoveAndDeleteChildren();
	// 	$('#cdb'+id).DeleteAsync(0);
	// }
	var cdb = $.CreatePanel('Panel', $('#containerPanel'), 'countDownBarPanel'+id);
	cdb.AddClass("countDownPanel");
	var cdbTitlePanel = $.CreatePanel('Panel', cdb, 'countDownTitlePanel'+id);
	cdbTitlePanel.AddClass("countDownTitlePanel");
	var cdbTitle = $.CreatePanel('Label', cdbTitlePanel, 'countDownBarTitle'+id);
	cdbTitle.AddClass("countDownTitle");
	var cdbBarBg = $.CreatePanel('Panel', cdb, 'countDownBarBg'+id);
	cdbBarBg.AddClass("countDownBarBg");
	var cdbBar = $.CreatePanel('Panel', cdbBarBg, 'countDownBar'+id);
	cdbBar.AddClass('countDownBar');
	
	cdbTitle.text = title;
	cdbBar.style.width = '0%';
	
	//var lineContainer = $.CreatePanel('Panel', cdb, 'cdb'+id+'#LineContainer');
	//lineContainer.AddClass('cdbLineContainer');
	//updateCountDownBar(30,100);

}

function refreshCdBar(data){

	var cdPanel = $('#countDownBarPanel'+data.id) ;
	if (data.curTime==data.total) {
		
		cdPanel.RemoveAndDeleteChildren();
	  	cdPanel.DeleteAsync(0);

	 	//此处可以加一段动画
	 	return ;
	}
	var cdPercent = $('#countDownBar'+data.id);
	cdPercent.style.width = ((data.curTime/data.total)*100)+'%';
}

function refreshCountDownBar(data){

	var cdbar = $('#countDownBarPanel'+data.id) ;
	if (cdbar==null ||cdbar==undefined) {
		addNewCdBar(data.id,data.name.format(data.params));
	}else {
		refreshCdBar(data);
	}
}

function addPermanentBar(data) {

	var cdBar = $('#countDownBarPanel'+data.id);
	// if (data.opt&&cdBar) {
	// 	cdBar.RemoveAndDeleteChildren();
	//   	cdBar.DeleteAsync(0);
	// }else 
	if(!cdBar){
		var cdb = $.CreatePanel('Panel', $('#containerPanel'), 'countDownBarPanel'+data.id);
		cdb.AddClass("countDownPanel");
		var cdbTitlePanel = $.CreatePanel('Panel', cdb, 'countDownTitlePanel'+data.id);
		cdbTitlePanel.AddClass("countDownTitlePanel");
		var cdbTitle = $.CreatePanel('Label', cdbTitlePanel, 'countDownBarTitle'+data.id);
		cdbTitle.AddClass("countDownTitle");
		cdbTitle.text = data.name.format(data.params);
	}
	
}

(function () {
  GameEvents.Subscribe( "startCountDown", startCountDown );
  String.prototype.format = function(args) {
  	var ret = this;
  	var last = ret.length;
 	var index = 0;

 	for (var i=ret.length-1;i>=0;i--) {
 		if (ret[i]=='}') {
 			var substr = ret.substring(i+1,last);

 			ret = ret.replace(substr,$.Localize(substr));
 			while(ret[i--]!='{');
 			last = i+1;
 		}
 	}
 	var substr = ret.substring(0,last);

 	ret = ret.replace(substr,$.Localize(substr));
  	for(var i in args) {
  		if(args[i]!=undefined) {
  			args[i] = $.Localize(args[i]);
  			ret = ret.replace('{'+index+'}',args[i]);
  			index++;
  		}
  		
  	}
  	return ret;
  };
  GameEvents.Subscribe("refresh_countDownBar",refreshCountDownBar);
  GameEvents.Subscribe("addPermanentBar",addPermanentBar);
})();


