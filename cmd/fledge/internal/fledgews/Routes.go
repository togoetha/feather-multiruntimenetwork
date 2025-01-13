package fledgews

import (
	"net/http"

	"github.com/gorilla/mux"
)

type Route struct {
	Name        string
	Method      string
	Pattern     string
	HandlerFunc http.HandlerFunc
	Queries     []string
}

type Routes []Route

func KubeletRouter() *mux.Router {

	router := mux.NewRouter().StrictSlash(true)
	for _, route := range kubroutes {
		router.
			Methods(route.Method).
			Path(route.Pattern).
			Name(route.Name).
			Handler(route.HandlerFunc)
		//Queries(route.Queries)
	}

	return router
}

var kubroutes = Routes{
	Route{
		Name:        "statsSummary",
		Method:      "GET",
		Pattern:     "/stats/summary/",
		HandlerFunc: StatsSummary,
		Queries:     []string{},
	},
	Route{
		Name:        "deployPod",
		Method:      "POST",
		Pattern:     "/deployPod",
		HandlerFunc: DeployPod,
		Queries:     []string{},
	},
	Route{
		Name:        "deletePod",
		Method:      "DELETE",
		Pattern:     "/deletePod",
		HandlerFunc: DeletePod,
		Queries:     []string{},
	},
}
