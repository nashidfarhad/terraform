locals {
    env = {
        staging = {
            vpc_id = "vpc-f7c03790"
            subnet_id = "subnet-cb0db3ac"
            domain_name = "example.com.au"
            domain_alt_names = ["*.example.com.au"]
            subdomains = [
                "brickworks",
                "carnextdoor",
                "caroma",
                "cba",
                "drivemycar",
                "each",
                "hearingaustralia",
                "macquariebrokers",
                "nielsen",
                "sgfleet",
                "splend",
                "test",
                "tyres4u",
                "www",
                "url9383"
            ]
        }
    }
    workspace = "${local.env["${terraform.workspace}"]}"
}