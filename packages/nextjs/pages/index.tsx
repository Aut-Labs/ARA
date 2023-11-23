import Link from "next/link";
import type { NextPage } from "next";
import { BugAntIcon, MagnifyingGlassIcon } from "@heroicons/react/24/outline";
import { MetaHeader } from "~~/components/MetaHeader";
import {CreateBadgeForm} from "~~/components/CreateBadge";

const Home: NextPage = () => {
  return (
    <>
      <MetaHeader />
      <br></br>
      <div className="flex items-center flex-col flex-grow pt-10">

    <CreateBadgeForm />

      </div>
    </>
  );
};

export default Home;
