
$ ()->
  $("#events_table").tablesorter().tablesorterPager({container: $("#pager")})
  
  
  $('#recurring_types > li > a').click(()->
    $('#event_recurring_type').val(@.text)
  )

  if $('.recurring_select > option:selected').val()=='null'
    $('.recurring_select > option:selected').text('One Time Event')

  is_one_time_event = () ->
    result = false
    $.each $('.recurring_select > option'), (i,val)->
      console.log $(val).attr('value')
      if($(val).attr('value')=='null')
        result = true
        return
    return result

  if !is_one_time_event()
    console.log 'not one time event'
    $('.recurring_select').prepend($('<option value ="null">One Time Event</option>'))

  change_visible_calendars = (max_visible)->
    min_visible_cal = max_visible_cal - 5
    for i in [0..calendars_count]
      $('.calendars .checkbox').hide()
    for i in [min_visible_cal..max_visible]
      $('.calendars .checkbox:nth('+i+')').show()
  max_visible_cat = max_visible_cal = 5
  calendars_count = $('.calendars .checkbox').size()
  $('#up-arrow-cal').click(()->
    max_visible_cal-- if max_visible_cal > 5
    change_visible_calendars(max_visible_cal)
  )
  $('#down-arrow-cal').click(()->
    max_visible_cal++ if calendars_count > max_visible_cal
    change_visible_calendars(max_visible_cal)
  )

  change_visible_categories = (max_visible)->
    min_visible_cat = max_visible_cat - 5
    for i in [0..categories_count]
      $('.categories .checkbox').hide()
    for i in [min_visible_cat..max_visible]
      $('.categories .checkbox:nth('+i+')').show()
  categories_count = $('.categories .checkbox').size()
  $('#up-arrow-cat').click(()->
    max_visible_cat-- if max_visible_cat > 5
    change_visible_categories(max_visible_cat)
  )
  $('#down-arrow-cat').click(()->
    max_visible_cat++ if categories_count > max_visible_cat
    change_visible_categories(max_visible_cat)
  )
  $('.datepicker').datepicker({
    dateFormat: "dd MM,yy"
  })
  unless typeof(calendar_id)=='undefined'
    $('#calendar').fullCalendar({
      editable: false
      events: '/schedule.json?calendar_id='+calendar_id
      eventBackgroundColor: 'red'
      timeFormat: 'hh:mm tt { - hh:mm tt}'
    })

  $.getJSON(location.origin+'/events/all_locations.json',null,(data)->
    locations = data
    $('#event_location').autocomplete({
      source: data,
      open: (event, ui)->
        $(".ui-menu").css("color", 'white').css('list-style','none')
    })
  )

