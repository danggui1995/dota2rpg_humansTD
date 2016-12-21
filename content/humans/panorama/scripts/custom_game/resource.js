
function refreshGold(data)
{
  var gold = data.gold;
  $('#gold_label').text = gold;
 // $.Msg(gold);
}
function UpdateGold()
{
  var queryUnit = Players.GetLocalPlayerPortraitUnit();
  for(var i = 0;i<5;i++)
  {
    if (  Players.IsValidPlayerID( i ))
    {
      if (Entities.IsControllableByPlayer( queryUnit,i ))
      {
        var m_data = CustomNetTables.GetTableValue( "gold", "GoldInfo" );
        if (m_data)
        {
          $('#gold_label').text=m_data[i+1]['gold'];
        }
      }
    }
    
  }

  $.Schedule(0.1,UpdateGold);

}

(function () {
  UpdateGold();
  GameEvents.Subscribe( "__refresh__gold", refreshGold );
  GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_GOLD, false ); 
  GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateGold );
  GameEvents.Subscribe( "dota_player_update_query_unit", UpdateGold );
/*  GameEvents.Subscribe( "top_notification", TopNotification );
  GameEvents.Subscribe( "bottom_notification", BottomNotification );
  GameEvents.Subscribe( "top_remove_notification", TopRemoveNotification );
  GameEvents.Subscribe( "bottom_remove_notification", BottomRemoveNotification );
  GameEvents.Subscribe( "midleft_notification", MidLeftNotification );
  GameEvents.Subscribe( "midleft_remove_notification", MidLeftRemoveNotification );
  GameUI.CustomUIConfig().errorMessage = BottomNotification;*/
})();


