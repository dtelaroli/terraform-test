package test

import (
	"flag"
	"fmt"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"testing"
)

type project struct {
	name, dir, description string
}

var shared = project{
	name:        "shared",
	dir:         "./shared",
	description: "Shared resources to be applied by Terraform",
}

var nginxApp = project{
	name:        "nginxApp",
	dir:         "./applications/nginx-app",
	description: "Nginx App to be applied by Terraform",
}

var projects = []project{shared, nginxApp}

func TestNginxApp(t *testing.T) {
	for _, project := range projects {

		item := flag.String(project.name, project.dir, project.description)
		flag.Parse()

		fmt.Println("[+] Testing ", *item)

		options := &terraform.Options{
			TerraformDir: test_structure.CopyTerraformFolderToTemp(t, "../", *item),
		}

		terraform.Init(t, options)

		workspace := "default"
		if project.name == nginxApp.name {
			workspace = "stg"
		}
		terraform.WorkspaceSelectOrNewE(t, options, workspace)

		_, err := terraform.ApplyE(t, options)

		if err != nil {
			t.Fail()
		}

		if project.name == nginxApp.name {
			defer terraform.Destroy(t, options)
		}
	}

}
