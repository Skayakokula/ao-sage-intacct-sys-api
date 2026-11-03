%dw 2.0
output application/xml

var entityConfig = {
    vendor: {
        object: "VENDOR",
        detailOperation: "readByName"
    }
}

var sageObject =
    entityConfig[vars.entity].object

---
{
    request: {

        control: {
            senderid: p("sage.senderId"),
            password: p("sage.senderPassword"),
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

                function @(controlid: uuid()):

                    if (vars.operation == "list")

                        {
                            query: {

                                object: sageObject,

                                select: {
                                    field: [
                                        "VENDORID",
                                        "RECORDNO",
                                        "PAYTOCONTACT.CONTACTNAME",
                                        "TOTALDUE",
                                        "WHENMODIFIED"
                                    ]
                                },

                                (filter:
                                    {
                                        greaterthanorequalto: {
                                            field: "WHENMODIFIED",
                                            value: vars.requestPayload.modifiedFrom
                                        }
                                    }
                                )
                                if (vars.requestPayload.modifiedFrom != null)
                            }
                        }

                    else if (vars.operation == "details")

                        {
                            readByName: {
                                object: sageObject,
                                keys: vars.requestPayload.vendorId,
                                fields: "*"
                            }
                        }

                    else
                        {}
            }
        }
    }
}
