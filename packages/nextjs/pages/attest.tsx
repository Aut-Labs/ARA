
import React from 'react';
import { useEffect } from "react";
import type { NextPage } from "next";
import { useLocalStorage } from "usehooks-ts";
import {AttestForUser} from "~~/components/AttestFor";

const AttestPage: React.FC = () => {
    return (

<div>
        {/* <MetaHeader /> */}
        <br></br>
        <div className="flex items-center flex-col flex-grow pt-10">
                    <div>
            <AttestForUser />
        </div>
        </div>

</div>

    );
};

export default AttestPage;
