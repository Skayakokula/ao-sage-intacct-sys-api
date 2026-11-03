%dw 2.0
output application/xml

var entityConfig = {

    vendor: {
        objectName: "VENDOR",
        operation: "readByName"
    },

    employee: {
        objectName: "EMPLOYEE",
        operation: "readByName"
    }

}

var config = entityConfig[vars.entity]

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
                sessionid: vars.sessionId
            },

            content: {

                function @(controlid: uuid()): {

                    readByName: {

                        object: config.objectName,

                        keys: vars.currentId,

                        fields: "*"

                    }

                }

            }

        }

    }
}
