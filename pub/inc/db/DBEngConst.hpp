/*!
 * \file DBEngConst.hpp
 * \project BetterQuant
 *
 * \author byrnexu
 * \date 2022/09/08
 *
 * \brief
 */

#pragma once

#include "util/Pch.hpp"

namespace bq::db {

const static std::string DEFAULT_DB_ENG_PARAM =
    "svcName=mysql; host=192.168.222.188; port=3306; username=root; password=123456; "
    "dbname=BetterQuant; connPoolSizeOfSyncReq=1; connPoolSizeOfAsyncReq=1; "
    "numOfUnprocessedTaskAlert=100; timeDurOfWaitForTask=500";

}  // namespace bq::db
