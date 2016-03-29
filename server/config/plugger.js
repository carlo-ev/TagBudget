function defineHandler(handler){
	if(!handler)
		return;
	var controller;
	if(typeof handler == "function")
		return handler;
	else if(typeof handler == "string"){
		handler = handler.split('#');
		handler[0] = handler[0][0].toUpperCase() + handler[0].slice(1) + 'Controller.js';
		try{
			controller = require( path.resolve('./server/controllers/'+handler[0]) );
		}catch(error){
			controller = null;
		}
		if(controller && controller[handler[1]])
			return controller[handler[1]];
	}
	throw new Error('Unsupported Handler of type '+ typeof handler);
}
module.exports.init = function(){
	var resourceFunctions,
		prefix = '/', 
		self = this;


	root = function(handler){
		Router.get('/', defineHandler(handler));
	};

	get = function(route, middle, handler){
		console.log(prefix+route);
		if(handler)
			Router.get(prefix+route, middle, defineHandler(handler));
		else
			Router.get(prefix+route, defineHandler(middle));
	};

	put = function(route, middle, handler){
		console.log(prefix+route);
		if(handler)
			Router.put(prefix+route, middle, defineHandler(handler));
		else
			Router.put(prefix+route, defineHandler(middle));
	};

	post = function(route, middle, handler){ 
		console.log(prefix+route);
		if(handler)
			Router.post(prefix+route, middle, defineHandler(handler));
		else
			Router.post(prefix+route, defineHandler(middle));
	};

	destroy = function(route, middle, handler){
		console.log(prefix+route);
		if(handler)
			Router.destroy(prefix+route, middle, defineHandler(handler));
		else
			Router.destroy(prefix+route, defineHandler(middle));
	};

	resourceFunctions = {
		index: function(baseRoute, manager){ 
			get.apply(self, arguments);
		},
		create: function(baseRoute, manager){
			post.apply(self, arguments);
		},
		show: function(baseRoute, manager){ 
			var showRoute;
			showRoute = '/:id';
			if(baseRoute.indexOf(':id') > -1)
				showRoute += (baseRoute+split(':id').length-1); 
			get(baseRoute+showRoute, manager);
		},
		update: function(baseRoute, manager){
			var showRoute;
			showRoute = '/:id'
			if(baseRoute.indexOf(':id') > -1)
				showRoute += (baseRoute.split(':id').length-1);
			put(baseRoute+showRoute, manager);
		},
		destroy: function(baseRoute, manager){
			var showRoute;
			showRoute = '/:id';
			if(baseRoute.indexOf(':id') > -1)
				showRoute += (baseRoute.split(':id').length-1);
		}
	};

	resource = function(){
		var route, resourceRoutes, arg;
		route = arguments[0];
		resourceRoutes = ['index','create','show','update','destroy'];
		arg = arguments[1]
		if(typeof arg == 'object'){
			if(arg.only)
				resourceRoutes = arg.only;
			else if(arg.except)
				for(rule in arg.except){
					var ruleIndex = resourceRoutes.indexOf(rule);
					if(ruleIndex > -1)
						resourceRoutes.splice(ruleIndex, 1);
				}
		}
		if(typeof arg  == 'function'){
			var oldPrefix;
			oldPrefix = prefix;
			prefix = route+prefix;
			arg();
			prefix = oldPrefix;
		}
		for(rest in resourceRoutes){
			resourceFunctions[rest](route)
			ApplicationController.bindController(route, rest, function(controllerFunction){
				resourceFunctions[rest](route, controllerFunction);
			});
		}
	};
}