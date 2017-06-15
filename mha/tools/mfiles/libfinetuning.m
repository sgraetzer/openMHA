function sLib = libfinetuning()
% LIBFINETUNING - function handle library
%
% Usage:
% libfinetuning()
%
% Help to function "fun" can be accessed by calling
% finetuning.help.fun()
%

% This file was generated by "bake_mlib finetuning".
% Do not edit! Edit sources finetuning_*.m instead.
%
% Date: 09-Jun-2017 14:42:43
sLib = struct;
sLib.apply = @finetuning_apply;
sLib.help.apply = @help_apply;
sLib.deletegui = @finetuning_deletegui;
sLib.help.deletegui = @help_deletegui;
sLib.drawgui = @finetuning_drawgui;
sLib.help.drawgui = @help_drawgui;
sLib.get_method = @finetuning_get_method;
sLib.help.get_method = @help_get_method;
sLib.get_val = @finetuning_get_val;
sLib.help.get_val = @help_get_val;
sLib.init = @finetuning_init;
sLib.help.init = @help_init;
sLib.interp_f = @finetuning_interp_f;
sLib.help.interp_f = @help_interp_f;
sLib.triggerguicallback = @finetuning_triggerguicallback;
sLib.help.triggerguicallback = @help_triggerguicallback;
sLib.updategui = @finetuning_updategui;
sLib.help.updategui = @help_updategui;
assignin('caller','finetuning',sLib);


function sGt = finetuning_apply( sFT, sGt )
% apply finetuning to a gain table
  sFT = finetuning_interp_f( sFT, sGt.frequencies );
  for ch='lr'
    sGt.(ch) = sGt.(ch) + repmat(sFT.(ch).gain,[size(sGt.(ch),1),1]);
    sGt.(ch) = min(sGt.(ch),repmat(sFT.(ch).maxgain,[size(sGt.(ch),1),1]));
  end


function help_apply
disp([' APPLY - finetuning to a gain table',char(10),'',char(10),' Usage:',char(10),'  finetuning = libfinetuning();',char(10),'  sGt = finetuning.apply( sFT, sGt );',char(10),'',char(10),'']);


function dummy = finetuning_deletegui
  vObj = findobj('type','uicontrol');
  delete(vObj(strmatch('finetuning_',get(vObj,'tag'))));
  dummy = 0;


function help_deletegui
disp([' DELETEGUI - ',char(10),'',char(10),' Usage:',char(10),'  finetuning = libfinetuning();',char(10),'  dummy = finetuning.deletegui();',char(10),'']);


function sFT = finetuning_drawgui( sFT, channel, pos, fh, callback, varargin )
  if nargin < 1
    sFT = finetuning_init;
  end
  if nargin < 2
    channel = 1;
  end
  if nargin < 3
    pos = [0 0 240 165];
  end
  guiw = pos(3);
  guih = pos(4);
  pos(3:4) = 0;
  if nargin < 4
    fh = figure;
  end
  if nargin < 5
    callback = @disp;
  end
  csSide = {'right ear','left ear'};
  ch = csSide{channel}(1);
  spos = pos;
  vCol = [0.6,0.4,0.4]*(2-channel)+[0.4,0.4,0.6]*(channel-1);
  uicontrol('style','frame','position',pos+[0,0,guiw,guih],...
	    'backgroundcolor',vCol,...
	    'tag',['finetuning_frame_',ch]);
  %uicontrol('style','text','position',pos+[5,guih-30,guiw-45,25],...
  %	    'backgroundcolor',vCol,...
  %	    'String',[csSide{channel},' ',method],'FontSize',14,'FontWeight','bold',...
  %	    'HorizontalAlignment','left',...
  %	    'tag','finetuning_frame');
  uicontrol('style','popupmenu','position',pos+[5,guih-40,guiw-10,35],...
	    'String',{'gain','maxgain'},'Value',1,...
	    'tag',['finetuning_method_',ch],...
	    'callback',@priv_cb_setmethod,...
	    'FontSize',14,'FontWeight','bold');
  global finetuning_sFT;
  finetuning_sFT = sFT;
  ud = struct('ch',ch,'callback',callback,'callback_data',{varargin});
  for k=1:length(sFT.f)
    f = sFT.f(k);
    fmin = 100;
    fmax = 8000;
    xpos = round(9+(k-1)/(length(sFT.f)-1)*(guiw-78));
    if f < 1000
      fstr = sprintf('%g',f);
    else
      fstr = sprintf('%gk',f/1000);
    end
    uicontrol('style','text','string',fstr,...
	      'position',pos+[xpos-5,102,30,16],...
	      'Fontsize',9,'fontweight','bold','backgroundcolor',vCol,...
	      'tag','finetuning_frame');
    uicontrol('style','pushbutton','string','+5',...
	      'position',pos+[xpos+2,84,18,18],...
	      'callback',@priv_cb_cmd_inc,...
	      'UserData',merge_structs(ud,struct('delta',5,'k',k)),...
	      'fontsize',8,...
	      'tag','finetuning_frame');
    uicontrol('style','pushbutton','string','+1',...
	      'position',pos+[xpos,62,22,22],...
	      'callback',@priv_cb_cmd_inc,...
	      'UserData',merge_structs(ud,struct('delta',1,'k',k)),...
	      'tag','finetuning_frame');
    uicontrol('style','text',...
	      'tag',sprintf('finetuning_val_%s_%d',ch,k),...
	      'position',pos+[xpos-5,46,30,16],...
	      'Fontsize',9,'fontweight','bold',...
	      'backgroundcolor',[1,0.87,0.3]);
    uicontrol('style','pushbutton','string','-1',...
	      'position',pos+[xpos,24,22,22],...
	      'callback',@priv_cb_cmd_inc,...
	      'UserData',merge_structs(ud,struct('delta',-1,'k',k)),...
	      'tag','finetuning_frame');
    uicontrol('style','pushbutton','string','-5',...
	      'position',pos+[xpos+2,6,18,18],...
	      'callback',@priv_cb_cmd_inc,...
	      'UserData',merge_structs(ud,struct('delta',-5,'k',k)),...
	      'fontsize',8,...
	      'tag','finetuning_frame');
  end
  xpos = guiw-32;
  uicontrol('style','text','string','bb',...
	    'position',pos+[xpos-5,104,30,16],...
	    'Fontsize',9,'fontweight','bold','backgroundcolor',vCol,...
	    'tag','finetuning_frame');
  uicontrol('style','pushbutton','string','+5',...
	    'position',pos+[xpos+2,86,18,18],...
	    'callback',@priv_cb_cmd_inc,...
	    'UserData',merge_structs(ud,struct('delta',5)),...
	    'fontsize',8,...
	    'tag','finetuning_frame');
  uicontrol('style','pushbutton','string','+1',...
	    'position',pos+[xpos,64,22,22],...
	    'callback',@priv_cb_cmd_inc,...
	    'UserData',merge_structs(ud,struct('delta',1)),...
	    'tag','finetuning_frame');
  uicontrol('style','pushbutton','string','zero!',...
	    'position',pos+[xpos-7,44,34,20],...
	    'Fontsize',9,'fontweight','bold',...
	    'callback',@priv_cb_cmd_bb_zero,...
	    'UserData',ud,...
	    'tag','finetuning_frame');
  uicontrol('style','pushbutton','string','-1',...
	    'position',pos+[xpos,22,22,22],...
	    'callback',@priv_cb_cmd_inc,...
	    'UserData',merge_structs(ud,struct('delta',-1)),...
	    'tag','finetuning_frame');
  uicontrol('style','pushbutton','string','-5',...
	    'position',pos+[xpos+2,4,18,18],...
	    'callback',@priv_cb_cmd_inc,...
	    'UserData',merge_structs(ud,struct('delta',-5)),...
	    'fontsize',8,...
	    'tag','finetuning_frame');
  finetuning_updategui;

function priv_cb_cmd_bb_zero(varargin)
  try
    ud = get(gcbo,'UserData');
    priv_set_val(ud.ch,zeros(size(finetuning_get_val(ud.ch))));
    finetuning_updategui;
    global finetuning_sFT;
    ud.callback(finetuning_sFT,ud.callback_data{:});
  catch
    disp_err_rethrow;
  end

function priv_cb_cmd_inc(varargin)
  try
    ud = get(gcbo,'UserData');
    if isfield(ud,'k')
      priv_set_val(ud.ch,ud.k,finetuning_get_val(ud.ch,ud.k)+ud.delta);
    else
      priv_set_val(ud.ch,finetuning_get_val(ud.ch)+ud.delta);
    end
    finetuning_updategui;
    global finetuning_sFT;
    ud.callback(finetuning_sFT,ud.callback_data{:});
  catch
    disp_err_rethrow;
  end
  
function priv_cb_setmethod(varargin)
  try
  val = get(gcbo,'Value');
  for ch='lr'
    set(findobj('tag',['finetuning_method_',ch]),'Value',val);
  end
  finetuning_updategui;
  catch
    disp_err_rethrow;
  end
  
function priv_set_val( ch, band, val )
  global finetuning_sFT;
  sMethod = finetuning_get_method(ch);
  if ~isempty(sMethod)
    if nargin == 3
      finetuning_sFT.(ch).(sMethod)(band) = val;
    else
      finetuning_sFT.(ch).(sMethod) = band;
    end
  end
  

function help_drawgui
disp([' DRAWGUI - uicontrol(''style'',''text'',''position'',pos+[5,guih-30,guiw-45,25],...',char(10),'',char(10),' Usage:',char(10),'  finetuning = libfinetuning();',char(10),'  sFT = finetuning.drawgui( sFT, channel, pos, fh, callback, varargin );',char(10),'',char(10),'	    ''backgroundcolor'',vCol,...',char(10),'	    ''String'',[csSide{channel},'' '',method],''FontSize'',14,''FontWeight'',''bold'',...',char(10),'	    ''HorizontalAlignment'',''left'',...',char(10),'	    ''tag'',''finetuning_frame'');',char(10),'']);


function sMethod = finetuning_get_method( ch )
  cf_children = get(gcf,'children');
  h = cf_children(strcmp(get(cf_children,'tag'),['finetuning_method_',ch]));
  if ~isempty(h)
    csMethods = get(h,'String');
    sMethod = csMethods{get(h,'Value')};
  else 
    sMethod = '';
  end


function help_get_method
disp([' GET_METHOD - ',char(10),'',char(10),' Usage:',char(10),'  finetuning = libfinetuning();',char(10),'  sMethod = finetuning.get_method( ch );',char(10),'']);


function val = finetuning_get_val( ch, band )
  global finetuning_sFT;
  sMethod = finetuning_get_method(ch);
  if ~isempty(sMethod)
    if nargin == 2
      val = finetuning_sFT.(ch).(sMethod)(band);
    else
      val = finetuning_sFT.(ch).(sMethod);
    end
  else
    val = [];
  end


function help_get_val
disp([' GET_VAL - ',char(10),'',char(10),' Usage:',char(10),'  finetuning = libfinetuning();',char(10),'  val = finetuning.get_val( ch, band );',char(10),'']);


function sFT = finetuning_init( f )
  if nargin < 1
    f = 1000*2.^[-2:3];
  end
  sFT = struct;
  sFT.f = f;
  sFT.l = struct('gain',zeros(size(f)),'maxgain',60+zeros(size(f)));
  sFT.r = sFT.l;


function help_init
disp([' INIT - ',char(10),'',char(10),' Usage:',char(10),'  finetuning = libfinetuning();',char(10),'  sFT = finetuning.init( f );',char(10),'']);


function sFT = finetuning_interp_f( sFT, f )
  interpf = [log(min(min(sFT.f),min(f)))-1,...
	     log(sFT.f(:)'),...
	     log(max(max(sFT.f),max(f)))+1];
  for ch='lr'
    for fn=fieldnames(sFT.(ch))'
      data = sFT.(ch).(fn{:})(:)';
      data = [data(1),data,data(end)];
      sFT.(ch).(fn{:}) = ...
	  interp1(interpf,data,log(f),...
		  'linear','extrap');
    end
  end
  sFT.f = f;


function help_interp_f
disp([' INTERP_F - ',char(10),'',char(10),' Usage:',char(10),'  finetuning = libfinetuning();',char(10),'  sFT = finetuning.interp_f( sFT, f );',char(10),'']);


function sFT = finetuning_triggerguicallback
  global finetuning_sFT;
  sFT = finetuning_sFT;
  vh = findobj('tag','finetuning_frame');
  if ~isempty(vh)
    for h=vh(:)'
      ud = get(h,'UserData');
      if ~isempty(ud)
	if isstruct(ud)
	  if isfield(ud,'callback')
	    ud.callback(finetuning_sFT,ud.callback_data{:});
	    return;
	  end
	end
      end
    end
  end


function help_triggerguicallback
disp([' TRIGGERGUICALLBACK - ',char(10),'',char(10),' Usage:',char(10),'  finetuning = libfinetuning();',char(10),'  sFT = finetuning.triggerguicallback();',char(10),'']);


function sFT = finetuning_updategui( sFT )
  global finetuning_sFT;
  if nargin >= 1
    if ~isequal(finetuning_sFT.f,sFT.f)
      error('not yet implemented');
    end
    finetuning_sFT = sFT;
  else
    sFT = finetuning_sFT;
  end
  cf_children = get(gcf,'children');
  cf_tags = get(cf_children,'tag');
  for ch='lr'
    for k=1:length(finetuning_sFT.f)
      set(cf_children(strcmp(cf_tags,sprintf('finetuning_val_%s_%d',ch,k))),'String',sprintf('%g',finetuning_get_val(ch,k)));
    end
  end


function help_updategui
disp([' UPDATEGUI - ',char(10),'',char(10),' Usage:',char(10),'  finetuning = libfinetuning();',char(10),'  sFT = finetuning.updategui( sFT );',char(10),'']);

