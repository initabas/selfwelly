// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require handlebars
//= require select2.full.js
//= require bootstrap-typeahead
//= require bootstrap-select.min.js
//= require ckeditor/config

$(document).on('ready page:load', function () {
  
  // ##################### Login #######################

  $('[id="sign-in"]').bind('ajax:success', function(e, data, status, xhr) {
    if(data.success) {
      $('#error-box').html(data.content);
      $('#modal-frm').modal('hide');
      $('#modal-frm').on('hidden.bs.modal', function (e) {
      	$.get("/ajax_reload/", {}, null, "script");
      });
    } else {
      $.growl(data.errors[0], {
        element: "body",
        placement: {
          from: "bottom",
          align: "left"
        },
        type: "danger",
        offset: 20,
        spacing: 10,
        z_index: 1031,
        delay: 5000,
        timer: 1000,
        animate: {
          enter: 'animated zoomInUp',
          exit: 'animated zoomOutDown'
        },
        icon_type: 'class',
        allow_dismiss: true
      });
      
      var fields = this;
      $(this).addClass('has-error');
      setTimeout(function(){
        $(fields).removeClass('has-error');
      }, 4000);
    }
  });
  

 
//  #################### End Login ##################
  
  
  $('.selectpicker').selectpicker();

  $('#search').select2({
    width: '500px',
    escapeMarkup: function(m) {return m;},
    placeholder: "Please enter tags",
    openOnEnter: false,
    templateNoMatches: function () {
      return "You must enter more characters...";
    },    
    ajax: {
      url: "srh",
      dataType: 'json',
      delay: 250,
      maximumSelectionSize: 1,
      data: function (params) {
        return {
          q: params.term
        };
      },
      processResults: function (data) {
        var ai = $.map(data.active_ingredients, function(obj) {
          return { id: obj._source.id,
                 type: obj._type,
                 name: obj._source.name,
         };
        });
        var m = $.map(data.medicines, function(obj) {
            var actives = "";
            if (obj._source.active_ingredients != "undefined") {
              for (i = 0; i < obj._source.active_ingredients.length; i++) {
                actives += obj._source.active_ingredients[i].name + ", ";
              }
              actives = actives.slice(0, -2);
            }
            
            return { id: obj._source.id,
                   type: obj._type,
                   name: obj._source.name,
                   a: actives
           };
          });
        
        
        return {

      
          results: m.concat(ai)
        };
      },
      cache: true
    },

    minimumInputLength: 3,
    templateResult: formatResult,
    // Specify format function for selected item
    templateSelection: formatSelection

  }).on("select2:select", function(e) {
          // mostly used event, fired to the original element when the value changes
    var array = $.map(e, function(value, index) {
      return [value];
    });
    window.location.href="/" + array[1].data.type + "s/" + array[1].data.id;
      console.log(array);
  });
  
  function formatResult(result, container, query, escapeMarkup) {
    if(!result.id) {
    // return `text` for optgroup
      return '<b style="text-align:center;">...</b>';
    }
    // return item template
//     var markup=[];
//     window.Select2.util.markMatch(result.name, query.term, markup, escapeMarkup);
//     markup_name = markup.join("");
//     markup=[];
//     window.Select2.util.markMatch(result.a, query.term, markup, escapeMarkup);
//     markup_a = markup.join("");

    return '<p value=' + result.id + '>' + result.name + '<span style="float: right">' + result.type + '</span>' + '</p>' + '<i>' + result.a + '</i>';

  }

  function formatSelection(item) {
    // return selection template
    return '<i>' + item.a + '</i>';
  }
  
});