local data = {
    [101] = {
        ["skillId"] = 101,
        ["eca"] = {
            ["eventId"] = 701,
            ["conditionList"] = {

            },
            ["trueActionList"] =
            {
                {
                    ["TYPE"] = 100,
                    ["unit"] = {
                            ["TYPE"] = 201,
                            ["unit"] = {
                                ["TYPE"] = 200,
                                    ["skill"] = {
                                        ["TYPE"] = 500,
                                    }
                            }
                    },
                    ["speed"] = {
                        ["TYPE"] = 400,
                        ["val"] = 2.5,
                    },
                    ["targetPos"] = {
                        ["TYPE"] = 301,
                        ["leftVal"] = {
                            ["TYPE"] = 302,
                            ["unit"] = {
                                ["TYPE"] = 201,
                                ["unit"] = {
                                    ["TYPE"] = 200,
                                        ["skill"] = {
                                            ["TYPE"] = 500,
                                        }
                                }
                            },
                        },
                        ["rightVal"] = {
                            ["TYPE"] = 300,
                            ["x"] = {
                                ["TYPE"] = 400,
                                ["val"] = 10,
                            },
                            ["y"] = {
                                ["TYPE"] = 400,
                                ["val"] = 20,
                            },
                            ["z"] = {
                                ["TYPE"] = 400,
                                ["val"] = 30,
                            },
                        },
                    },
                },
            },
            ["falseActionList"] = {

            },
        },
    },
    [102] = {

    },
}

return data
