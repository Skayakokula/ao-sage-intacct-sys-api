%dw 2.0
output application/xml
---
{
    request: {

        control: {
            senderid: p("sage.senderId"),
            password: p("secure::sage.senderPassword"),
            controlid: uuid(),
            uniqueid: false,
            dtdversion: "3.0",
            includewhitespace: false
        },

        operation: {

            authentication: {

                login: {
                    userid: p("sage.userId"),
                    companyid: p("sage.companyId"),
                    password: p("secure::sage.userPassword"),
                    locationid: if (vars.operationType == "update") null
else vars.locationId
                }
            },

            content: {

                function @(controlid: uuid()): {
                    getAPISession: null
                }
            }
        }
    }
}