# C4 template for the c4-diagrams skill. Copy it, then change the model and views.
# Rules: every element has name + description (+ technology for containers/components),
# external systems carry the tag "External", every view has a title and autoLayout tb.
workspace "Online Banking" "Interview sample" {
    model {
        customer = person "Personal Customer" "A customer of the bank with a personal account."
        bank = softwareSystem "Internet Banking System" "Lets customers view accounts and make payments." {
            spa = container "Single-Page App" "Banking features in the browser." "React" "Web Browser"
            api = container "API Application" "Provides banking features over JSON/HTTPS." "Java, Spring Boot" {
                signin = component "Sign-in Controller" "Lets users sign in." "Spring MVC"
                accounts = component "Accounts Controller" "Account summaries." "Spring MVC"
                security = component "Security Component" "Sign-in and password logic." "Spring Bean"
            }
            db = container "Database" "Users, hashed passwords, access logs." "PostgreSQL" "Database"
        }
        mainframe = softwareSystem "Mainframe Banking System" "Core banking records." "External"
        email = softwareSystem "E-mail System" "Microsoft Exchange." "External"

        customer -> spa "Uses" "HTTPS"
        spa -> signin "Signs in using" "JSON/HTTPS"
        spa -> accounts "Reads accounts using" "JSON/HTTPS"
        signin -> security "Uses"
        security -> db "Reads from and writes to" "JDBC"
        accounts -> mainframe "Reads data from" "XML/HTTPS"
        api -> email "Sends e-mail using" "SMTP"
        email -> customer "Sends e-mails to"
    }
    views {
        systemContext bank "C1-Context" "Internet Banking System — System Context Diagram" {
            include *
            autoLayout tb
        }
        container bank "C2-Container" "Internet Banking System — Container Diagram" {
            include *
            autoLayout tb
        }
        component api "C3-API-Components" "API Application — Component Diagram" {
            include *
            autoLayout tb
        }
        styles {
            element "Element" {
                color #ffffff
            }
            element "Person" {
                background #08427b
                shape Person
            }
            element "Software System" {
                background #1168bd
            }
            element "Container" {
                background #438dd5
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
            element "External" {
                background #999999
            }
            element "Database" {
                shape Cylinder
            }
            element "Web Browser" {
                shape WebBrowser
            }
        }
    }
}
