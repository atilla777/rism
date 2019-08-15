$(document).on('turbolinks:load', function() {
  $('a[data-set-date="discovered_at"]').on('click', {atrib: 'incident_discovered_at'}, set_today);
  $('a[data-set-date="started_at"]').on('click', {atrib: 'incident_started_at'}, set_today);
  $('a[data-set-date="finished_at"]').on('click', {atrib: 'incident_finished_at'}, set_today);
  $('a[data-set-date="beginning"]').on('click', {atrib: 'agreement_beginning'}, set_today);
  $('a[data-set-date="custom_published"]').on('click', {atrib: 'vulnerability_custom_published'}, set_today);
  $('a[data-set-time="discovered_at"]').on('click', {atrib: 'incident_discovered_at'}, set_now);
  $('a[data-set-time="started_at"]').on('click', {atrib: 'incident_started_at'}, set_now);
  $('a[data-set-time="finished_at"]').on('click', {atrib: 'incident_finished_at'}, set_now);
  $('a[data-set-time="custom_published"]').on('click', {atrib: 'vulnerability_custom_published'}, set_now);
});

function set_today(e) {
    var dt = new Date();
    t3 = document.getElementById(e.data.atrib + '_3i');
    t3.selectedIndex = dt.getDate() + 1;

    t2 = document.getElementById(e.data.atrib + '_2i')
    t2.selectedIndex = dt.getMonth() + 2;

    t1 = document.getElementById(e.data.atrib + '_1i')
    for (i = 0; i < t1.length; i++)
         {
            if (t1.options[i].text == dt.getFullYear())
            {
                t1.selectedIndex = i;
            }
         }
    e.preventDefault();
}

function set_now(e) {
    var dt = new Date();
    t2 = document.getElementById(e.data.atrib + '_5i');
    t2.selectedIndex = dt.getMinutes() + 2;

    t1 = document.getElementById(e.data.atrib + '_4i')
    t1.selectedIndex = dt.getHours() + 2;
    e.preventDefault();
}
