%dw 2.0
output application/xml

var entityConfig = {

    vendor: {
        objectName: "VENDOR",

        fields: [
            "VENDORID",
            "RECORDNO",
            "PAYTOCONTACT.CONTACTNAME",
            "TOTALDUE",
            "WHENMODIFIED"
        ],

        modifiedField: "WHENMODIFIED"
    },

    employee: {
        objectName: "EMPLOYEE",

        fields: [
            "EMPLOYEEID",
            "RECORDNO",
            "CONTACT.CONTACTNAME",
            "WHENMODIFIED"
        ],

        modifiedField: "WHENMODIFIED"
    }

}

var config = entityConfig[vars.entity]

var inputPayload = vars.requestPayload

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

                    query: {

                        object: config.objectName,

                        select: {
                            field: config.fields
                        },

                        (
                            filter: {
                                greaterthanorequalto: {
                                    field: config.modifiedField,
                                    value: inputPayload.modifiedFrom
                                }
                            }
                        )
                        if (inputPayload.modifiedFrom != null)

                    }
                }
            }
        }
    }
}
