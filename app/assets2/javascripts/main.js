//= require_self
//= require bootstrap

window.view = undefined;
var eventBus = _.extend({}, Backbone.Events);

renderPage = function() {
    if(!window.EMBEDDED_VIEW) {
        new GenericView({el: 'header',templateName: 'common__header'});
        new GenericView({el: 'footer',templateName: 'common__footer'});
    }

    if(window.renderTheMainWindow) {
        window.renderTheMainWindow();
        if(window.view)
            window.view.render();
    }

}

TEMPLATE_MANAGER = new TemplateManager();
TEMPLATE_MANAGER.fetchAll(renderPage);

