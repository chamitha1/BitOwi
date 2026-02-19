// ignore_for_file: constant_identifier_names, camel_case_types
/// //////////////////////////////////////////////////////////////////////////////
///
/// ä¸€. SDK æŽ¥å£å¸¸ç”¨é…ç½®é€‰é¡¹
///
/// //////////////////////////////////////////////////////////////////////////////
/// 1.1 è°ƒç”¨æŽ¥å£çš„è¿”å›žå€¼ï¼ˆè‹¥æŽ¥å£å‚æ•°ä¸­æœ‰å›žè°ƒï¼Œåªæœ‰å½“æŽ¥å£è¿”å›ž TIM_SUCC æ—¶ï¼Œå›žè°ƒæ‰ä¼šè¢«è°ƒç”¨ï¼‰
enum TIMResult {
  /// æŽ¥å£è°ƒç”¨æˆåŠŸ
  TIM_SUCC(0),

  /// æŽ¥å£è°ƒç”¨å¤±è´¥ï¼ŒImSDK æœªåˆå§‹åŒ–
  TIM_ERR_SDKUNINIT(-1),

  /// æŽ¥å£è°ƒç”¨å¤±è´¥ï¼Œç”¨æˆ·æœªç™»å½•
  TIM_ERR_NOTLOGIN(-2),

  /// æŽ¥å£è°ƒç”¨å¤±è´¥ï¼Œé”™è¯¯çš„ Json æ ¼å¼æˆ– Json Key
  TIM_ERR_JSON(-3),

  /// æŽ¥å£è°ƒç”¨å¤±è´¥ï¼Œå‚æ•°é”™è¯¯
  TIM_ERR_PARAM(-4),

  /// æŽ¥å£è°ƒç”¨å¤±è´¥ï¼Œæ— æ•ˆçš„ä¼šè¯
  TIM_ERR_CONV(-5),

  /// æŽ¥å£è°ƒç”¨å¤±è´¥ï¼Œæ— æ•ˆçš„ç¾¤ç»„
  TIM_ERR_GROUP(-6);

  final int value;
  const TIMResult(this.value);

  static TIMResult fromValue(int value) => switch (value) {
        0 => TIM_SUCC,
        -1 => TIM_ERR_SDKUNINIT,
        -2 => TIM_ERR_NOTLOGIN,
        -3 => TIM_ERR_JSON,
        -4 => TIM_ERR_PARAM,
        -5 => TIM_ERR_CONV,
        -6 => TIM_ERR_GROUP,
        _ => throw ArgumentError("Unknown value for TIMResult: $value"),
      };
}

/// 1.2 ä¼šè¯ç±»åž‹
enum TIMConvType {
  /// æ— æ•ˆä¼šè¯
  kTIMConv_Invalid(0),

  /// ä¸ªäººä¼šè¯
  kTIMConv_C2C(1),

  /// ç¾¤ç»„ä¼šè¯
  kTIMConv_Group(2),

  /// ç³»ç»Ÿä¼šè¯ï¼Œå·²åºŸå¼ƒ
  kTIMConv_System(3);

  final int value;
  const TIMConvType(this.value);

  static TIMConvType fromValue(int value) => switch (value) {
        0 => kTIMConv_Invalid,
        1 => kTIMConv_C2C,
        2 => kTIMConv_Group,
        3 => kTIMConv_System,
        _ => throw ArgumentError("Unknown value for TIMConvType: $value"),
      };
}

/// 1.3 æ¶ˆæ¯æŽ¥æ”¶é€‰é¡¹
enum TIMReceiveMessageOpt {
  /// åœ¨çº¿æ­£å¸¸æŽ¥æ”¶æ¶ˆæ¯ï¼Œç¦»çº¿æ—¶ä¼šè¿›è¡Œ APNs æŽ¨é€
  kTIMRecvMsgOpt_Receive(0),

  /// ä¸ä¼šæŽ¥æ”¶åˆ°æ¶ˆæ¯ï¼Œç¦»çº¿ä¸ä¼šæœ‰æŽ¨é€é€šçŸ¥
  kTIMRecvMsgOpt_Not_Receive(1),

  /// åœ¨çº¿æ­£å¸¸æŽ¥æ”¶æ¶ˆæ¯ï¼Œç¦»çº¿ä¸ä¼šæœ‰æŽ¨é€é€šçŸ¥
  kTIMRecvMsgOpt_Not_Notify(2),

  /// åœ¨çº¿æŽ¥æ”¶æ¶ˆæ¯ï¼Œç¦»çº¿åªæŽ¥æ”¶ at æ¶ˆæ¯çš„æŽ¨é€
  kTIMRecvMsgOpt_Not_Notify_Except_At(3),

  /// åœ¨çº¿å’Œç¦»çº¿éƒ½åªæŽ¥æ”¶@æ¶ˆæ¯
  kTIMRecvMsgOpt_Not_Receive_Except_At(4);

  final int value;
  const TIMReceiveMessageOpt(this.value);

  static TIMReceiveMessageOpt fromValue(int value) => switch (value) {
        0 => kTIMRecvMsgOpt_Receive,
        1 => kTIMRecvMsgOpt_Not_Receive,
        2 => kTIMRecvMsgOpt_Not_Notify,
        3 => kTIMRecvMsgOpt_Not_Notify_Except_At,
        4 => kTIMRecvMsgOpt_Not_Receive_Except_At,
        _ =>
          throw ArgumentError("Unknown value for TIMReceiveMessageOpt: $value"),
      };
}

/// //////////////////////////////////////////////////////////////////////////////
///
/// é”™è¯¯ç 
///
/// //////////////////////////////////////////////////////////////////////////////
/// è¯¦ç»† [é”™è¯¯ç ](https://cloud.tencent.com/document/product/269/1671)ï¼Œè¯·æ‚¨ç§»æ­¥å®˜ç½‘æŸ¥çœ‹
enum TIMErrCode {
  /// æ— é”™è¯¯ã€‚
  ERR_SUCC(0),

  /// æŽ¥å£æ­£åœ¨æ‰§è¡Œä¸­ï¼Œè¯·æ‚¨åœ¨æ”¶åˆ°å›žè°ƒä¹‹åŽï¼Œå†æ¬¡å‘èµ·å¯¹å½“å‰æŽ¥å£çš„è°ƒç”¨ï¼Œå³é‡‡ç”¨ä¸²è¡Œæ–¹å¼è°ƒç”¨æŽ¥å£ã€‚
  ERR_IN_PROGESS(6015),

  /// å‚æ•°æ— æ•ˆï¼Œè¯·æ£€æŸ¥å‚æ•°æ˜¯å¦ç¬¦åˆè¦æ±‚ï¼Œå…·ä½“å¯æŸ¥çœ‹é”™è¯¯ä¿¡æ¯è¿›ä¸€æ­¥å®šä¹‰å“ªä¸ªå­—æ®µã€‚
  ERR_INVALID_PARAMETERS(6017),

  /// æ“ä½œæœ¬åœ° IO é”™è¯¯ï¼Œæ£€æŸ¥æ˜¯å¦æœ‰è¯»å†™æƒé™ï¼Œç£ç›˜æ˜¯å¦å·²æ»¡ã€‚
  ERR_IO_OPERATION_FAILED(6022),

  /// é”™è¯¯çš„ JSON æ ¼å¼ï¼Œè¯·æ£€æŸ¥å‚æ•°æ˜¯å¦ç¬¦åˆæŽ¥å£çš„è¦æ±‚ï¼Œå…·ä½“å¯æŸ¥çœ‹é”™è¯¯ä¿¡æ¯è¿›ä¸€æ­¥å®šä¹‰å“ªä¸ªå­—æ®µã€‚
  ERR_INVALID_JSON(6027),

  /// å†…å­˜ä¸è¶³ï¼Œå¯èƒ½å­˜åœ¨å†…å­˜æ³„æ¼ï¼ŒiOS å¹³å°ä½¿ç”¨ Instrument å·¥å…·ï¼ŒAndroid å¹³å°ä½¿ç”¨ Profiler å·¥å…·ï¼Œåˆ†æžå‡ºä»€ä¹ˆåœ°æ–¹çš„å†…å­˜å ç”¨é«˜ã€‚
  ERR_OUT_OF_MEMORY(6028),

  /// PB è§£æžå¤±è´¥ï¼Œå†…éƒ¨é”™è¯¯ï¼Œå¯ [æäº¤å·¥å•](https://console.cloud.tencent.com/workorder/category?level1_id=29&level2_id=40&source=0&data_title=%E4%BA%91%E9%80%9A%E4%BF%A1%20%20IM&step=1) æä¾›ä½¿ç”¨æŽ¥å£ã€é”™è¯¯ç ã€é”™è¯¯ä¿¡æ¯ç»™å®¢æœè§£å†³ã€‚
  ERR_PARSE_RESPONSE_FAILED(6001),

  /// PB åºåˆ—åŒ–å¤±è´¥ï¼Œå†…éƒ¨é”™è¯¯ï¼Œå¯ [æäº¤å·¥å•](https://console.cloud.tencent.com/workorder/category?level1_id=29&level2_id=40&source=0&data_title=%E4%BA%91%E9%80%9A%E4%BF%A1%20%20IM&step=1) æä¾›ä½¿ç”¨æŽ¥å£ã€é”™è¯¯ç ã€é”™è¯¯ä¿¡æ¯ç»™å®¢æœè§£å†³ã€‚
  ERR_SERIALIZE_REQ_FAILED(6002),

  /// IM SDK æœªåˆå§‹åŒ–ï¼Œåˆå§‹åŒ–æˆåŠŸå›žè°ƒä¹‹åŽé‡è¯•ã€‚
  ERR_SDK_NOT_INITIALIZED(6013),

  /// åŠ è½½æœ¬åœ°æ•°æ®åº“æ“ä½œå¤±è´¥ï¼Œå¯èƒ½å­˜å‚¨æ–‡ä»¶æœ‰æŸåï¼Œå¯ [æäº¤å·¥å•](https://console.cloud.tencent.com/workorder/category?level1_id=29&level2_id=40&source=0&data_title=%E4%BA%91%E9%80%9A%E4%BF%A1%20%20IM&step=1) è”ç³»å®¢æœå®šä½å…·ä½“é—®é¢˜ã€‚
  ERR_LOADMSG_FAILED(6005),

  /// æœ¬åœ°æ•°æ®åº“æ“ä½œå¤±è´¥ï¼Œå¯èƒ½æ˜¯éƒ¨åˆ†ç›®å½•æ— æƒé™æˆ–è€…æ•°æ®åº“æ–‡ä»¶å·²æŸåã€‚
  ERR_DATABASE_OPERATE_FAILED(6019),

  /// è·¨çº¿ç¨‹é”™è¯¯ï¼Œä¸èƒ½åœ¨è·¨è¶Šä¸åŒçº¿ç¨‹ä¸­æ‰§è¡Œï¼Œå†…éƒ¨é”™è¯¯ï¼Œå¯ [æäº¤å·¥å•](https://console.cloud.tencent.com/workorder/category?level1_id=29&level2_id=40&source=0&data_title=%E4%BA%91%E9%80%9A%E4%BF%A1%20%20IM&step=1) æä¾›ä½¿ç”¨æŽ¥å£ã€é”™è¯¯ç ã€é”™è¯¯ä¿¡æ¯ç»™å®¢æœè§£å†³ã€‚
  ERR_SDK_COMM_CROSS_THREAD(7001),

  /// TinyId ä¸ºç©ºï¼Œå†…éƒ¨é”™è¯¯ï¼Œå¯ [æäº¤å·¥å•](https://console.cloud.tencent.com/workorder/category?level1_id=29&level2_id=40&source=0&data_title=%E4%BA%91%E9%80%9A%E4%BF%A1%20%20IM&step=1) æä¾›ä½¿ç”¨æŽ¥å£ã€é”™è¯¯ç ã€é”™è¯¯ä¿¡æ¯ç»™å®¢æœè§£å†³ã€‚
  ERR_SDK_COMM_TINYID_EMPTY(7002),

  /// Identifier éžæ³•ï¼Œå¿…é¡»ä¸ä¸ºç©ºï¼Œè¦æ±‚å¯æ‰“å° ASCII å­—ç¬¦ï¼ˆ0x20-0x7eï¼‰ï¼Œé•¿åº¦ä¸è¶…è¿‡32å­—èŠ‚ã€‚
  ERR_SDK_COMM_INVALID_IDENTIFIER(7003),

  /// æ–‡ä»¶ä¸å­˜åœ¨ï¼Œè¯·æ£€æŸ¥æ–‡ä»¶è·¯å¾„æ˜¯å¦æ­£ç¡®ã€‚
  ERR_SDK_COMM_FILE_NOT_FOUND(7004),

  /// æ–‡ä»¶å¤§å°è¶…å‡ºäº†é™åˆ¶ï¼Œè¯­éŸ³ã€å›¾ç‰‡ï¼Œæœ€å¤§é™åˆ¶æ˜¯28MBï¼Œè§†é¢‘ã€æ–‡ä»¶ï¼Œæœ€å¤§é™åˆ¶ 100M
  ERR_SDK_COMM_FILE_TOO_LARGE(7005),

  /// ç©ºæ–‡ä»¶ï¼Œè¦æ±‚æ–‡ä»¶å¤§å°ä¸æ˜¯0å­—èŠ‚ï¼Œå¦‚æžœä¸Šä¼ å›¾ç‰‡ã€è¯­éŸ³ã€è§†é¢‘æˆ–æ–‡ä»¶ï¼Œè¯·æ£€æŸ¥æ–‡ä»¶æ˜¯å¦æ­£ç¡®ç”Ÿæˆã€‚
  ERR_SDK_COMM_FILE_SIZE_EMPTY(7006),

  /// æ–‡ä»¶æ‰“å¼€å¤±è´¥ï¼Œè¯·æ£€æŸ¥æ–‡ä»¶æ˜¯å¦å­˜åœ¨ï¼Œæˆ–è€…å·²è¢«ç‹¬å æ‰“å¼€ï¼Œå¼•èµ· SDK æ‰“å¼€å¤±è´¥ã€‚
  ERR_SDK_COMM_FILE_OPEN_FAILED(7007),

  /// API è°ƒç”¨è¶…é¢‘
  ERR_SDK_COMM_API_CALL_FREQUENCY_LIMIT(7008),

  /// æ­£åœ¨æ‰§è¡Œæ—¶è¢«ç»ˆæ­¢ï¼Œä¾‹å¦‚æ­£åœ¨ç™»å½•æ—¶ï¼Œè°ƒç”¨ unInit åœæ­¢ä½¿ç”¨ SDK ã€‚
  ERR_SDK_COMM_INTERRUPT(7009),

  /// database æ“ä½œå¤±è´¥
  ERR_SDK_COMM_DATABASE_FAILURE(7010),

  /// database æŸ¥è¯¢çš„æ•°æ®ä¸å­˜åœ¨
  ERR_SDK_COMM_DATABASE_NOTFOUND(7011),

  /// SDK å†…éƒ¨ä¸åº”è¯¥å‡ºçŽ°çš„å†…éƒ¨é”™è¯¯
  ERR_SDK_INTERNAL_ERROR(7012),

  /// å¥—é¤åŒ…ä¸æ”¯æŒè¯¥æŽ¥å£çš„ä½¿ç”¨ï¼Œè¯·å‡çº§åˆ°æ——èˆ°ç‰ˆå¥—é¤
  ERR_SDK_INTERFACE_NOT_SUPPORT(7013),

  /// éžæ³•è¯·æ±‚
  ERR_SDK_INVALID_OPERATION(7014),

  /// IM SDK æœªç™»å½•ï¼Œè¯·å…ˆç™»å½•ï¼ŒæˆåŠŸå›žè°ƒä¹‹åŽé‡è¯•ï¼Œæˆ–è€…å·²è¢«è¸¢ä¸‹çº¿ï¼Œå¯ä½¿ç”¨ TIMManager getLoginUser æ£€æŸ¥å½“å‰æ˜¯å¦åœ¨çº¿ã€‚
  ERR_SDK_NOT_LOGGED_IN(6014),

  /// è‡ªåŠ¨ç™»å½•æ—¶ï¼Œå¹¶æ²¡æœ‰ç™»å½•è¿‡è¯¥ç”¨æˆ·ï¼Œè¿™æ—¶å€™è¯·è°ƒç”¨ login æŽ¥å£é‡æ–°ç™»å½•ã€‚
  ERR_NO_PREVIOUS_LOGIN(6026),

  /// UserSig è¿‡æœŸï¼Œè¯·é‡æ–°èŽ·å–æœ‰æ•ˆçš„ UserSig åŽå†é‡æ–°ç™»å½•ã€‚
  ERR_USER_SIG_EXPIRED(6206),

  /// å…¶ä»–ç»ˆç«¯ç™»å½•åŒä¸€ä¸ªè´¦å·ï¼Œå¼•èµ·å·²ç™»å½•çš„è´¦å·è¢«è¸¢ï¼Œéœ€é‡æ–°ç™»å½•ã€‚
  ERR_LOGIN_KICKED_OFF_BY_OTHER(6208),

  /// ç™»å½•æ­£åœ¨æ‰§è¡Œä¸­ï¼Œä¾‹å¦‚ï¼Œç¬¬ä¸€æ¬¡ login æˆ– autoLogin æ“ä½œåœ¨å›žè°ƒå‰ï¼ŒåŽç»­çš„ login æˆ– autoLogin æ“ä½œä¼šè¿”å›žè¯¥é”™è¯¯ç ã€‚
  ERR_SDK_ACCOUNT_LOGIN_IN_PROCESS(7501),

  /// ç™»å‡ºæ­£åœ¨æ‰§è¡Œä¸­ï¼Œä¾‹å¦‚ï¼Œç¬¬ä¸€æ¬¡ logout æ“ä½œåœ¨å›žè°ƒå‰ï¼ŒåŽç»­çš„ logout æ“ä½œä¼šè¿”å›žè¯¥é”™è¯¯ç ã€‚
  ERR_SDK_ACCOUNT_LOGOUT_IN_PROCESS(7502),

  /// TLS SDK åˆå§‹åŒ–å¤±è´¥ï¼Œå†…éƒ¨é”™è¯¯ï¼Œå¯ [æäº¤å·¥å•](https://console.cloud.tencent.com/workorder/category?level1_id=29&level2_id=40&source=0&data_title=%E4%BA%91%E9%80%9A%E4%BF%A1%20%20IM&step=1) æä¾›ä½¿ç”¨æŽ¥å£ã€é”™è¯¯ç ã€é”™è¯¯ä¿¡æ¯ç»™å®¢æœè§£å†³ã€‚
  ERR_SDK_ACCOUNT_TLS_INIT_FAILED(7503),

  /// TLS SDK æœªåˆå§‹åŒ–ï¼Œå†…éƒ¨é”™è¯¯ï¼Œå¯ [æäº¤å·¥å•](https://console.cloud.tencent.com/workorder/category?level1_id=29&level2_id=40&source=0&data_title=%E4%BA%91%E9%80%9A%E4%BF%A1%20%20IM&step=1) æä¾›ä½¿ç”¨æŽ¥å£ã€é”™è¯¯ç ã€é”™è¯¯ä¿¡æ¯ç»™å®¢æœè§£å†³ã€‚
  ERR_SDK_ACCOUNT_TLS_NOT_INITIALIZED(7504),

  /// TLS SDK TRANS åŒ…æ ¼å¼é”™è¯¯ï¼Œå†…éƒ¨é”™è¯¯ï¼Œå¯ [æäº¤å·¥å•](https://console.cloud.tencent.com/workorder/category?level1_id=29&level2_id=40&source=0&data_title=%E4%BA%91%E9%80%9A%E4%BF%A1%20%20IM&step=1) æä¾›ä½¿ç”¨æŽ¥å£ã€é”™è¯¯ç ã€é”™è¯¯ä¿¡æ¯ç»™å®¢æœè§£å†³ã€‚
  ERR_SDK_ACCOUNT_TLS_TRANSPKG_ERROR(7505),

  /// TLS SDK è§£å¯†å¤±è´¥ï¼Œå†…éƒ¨é”™è¯¯ï¼Œå¯ [æäº¤å·¥å•](https://console.cloud.tencent.com/workorder/category?level1_id=29&level2_id=40&source=0&data_title=%E4%BA%91%E9%80%9A%E4%BF%A1%20%20IM&step=1) æä¾›ä½¿ç”¨æŽ¥å£ã€é”™è¯¯ç ã€é”™è¯¯ä¿¡æ¯ç»™å®¢æœè§£å†³ã€‚
  ERR_SDK_ACCOUNT_TLS_DECRYPT_FAILED(7506),

  /// TLS SDK è¯·æ±‚å¤±è´¥ï¼Œå†…éƒ¨é”™è¯¯ï¼Œå¯ [æäº¤å·¥å•](https://console.cloud.tencent.com/workorder/category?level1_id=29&level2_id=40&source=0&data_title=%E4%BA%91%E9%80%9A%E4%BF%A1%20%20IM&step=1) æä¾›ä½¿ç”¨æŽ¥å£ã€é”™è¯¯ç ã€é”™è¯¯ä¿¡æ¯ç»™å®¢æœè§£å†³ã€‚
  ERR_SDK_ACCOUNT_TLS_REQUEST_FAILED(7507),

  /// TLS SDK è¯·æ±‚è¶…æ—¶ï¼Œå†…éƒ¨é”™è¯¯ï¼Œå¯ [æäº¤å·¥å•](https://console.cloud.tencent.com/workorder/category?level1_id=29&level2_id=40&source=0&data_title=%E4%BA%91%E9%80%9A%E4%BF%A1%20%20IM&step=1) æä¾›ä½¿ç”¨æŽ¥å£ã€é”™è¯¯ç ã€é”™è¯¯ä¿¡æ¯ç»™å®¢æœè§£å†³ã€‚
  ERR_SDK_ACCOUNT_TLS_REQUEST_TIMEOUT(7508),

  /// ä¼šè¯æ— æ•ˆï¼ŒgetConversation æ—¶æ£€æŸ¥æ˜¯å¦å·²ç»ç™»å½•ï¼Œå¦‚æœªç™»å½•èŽ·å–ä¼šè¯ï¼Œä¼šæœ‰æ­¤é”™è¯¯ç è¿”å›žã€‚
  ERR_INVALID_CONVERSATION(6004),

  /// æ–‡ä»¶ä¼ è¾“é‰´æƒå¤±è´¥ï¼Œå¯ [æäº¤å·¥å•](https://console.cloud.tencent.com/workorder/category?level1_id=29&level2_id=40&source=0&data_title=%E4%BA%91%E9%80%9A%E4%BF%A1%20%20IM&step=1) æä¾›ä½¿ç”¨æŽ¥å£ã€é”™è¯¯ç ã€é”™è¯¯ä¿¡æ¯ç»™å®¢æœè§£å†³ã€‚
  ERR_FILE_TRANS_AUTH_FAILED(6006),

  /// æ–‡ä»¶ä¼ è¾“èŽ·å– Server åˆ—è¡¨å¤±è´¥ï¼Œå¯ [æäº¤å·¥å•](https://console.cloud.tencent.com/workorder/category?level1_id=29&level2_id=40&source=0&data_title=%E4%BA%91%E9%80%9A%E4%BF%A1%20%20IM&step=1) æä¾›ä½¿ç”¨æŽ¥å£ã€é”™è¯¯ç ã€é”™è¯¯ä¿¡æ¯ç»™å®¢æœè§£å†³ã€‚
  ERR_FILE_TRANS_NO_SERVER(6007),

  /// æ–‡ä»¶ä¼ è¾“ä¸Šä¼ å¤±è´¥ï¼Œè¯·æ£€æŸ¥ç½‘ç»œæ˜¯å¦è¿žæŽ¥ã€‚
  ERR_FILE_TRANS_UPLOAD_FAILED(6008),

  /// æ–‡ä»¶ä¼ è¾“ä¸Šä¼ å¤±è´¥ï¼Œè¯·æ£€æŸ¥ä¸Šä¼ çš„å›¾ç‰‡æ˜¯å¦èƒ½å¤Ÿæ­£å¸¸æ‰“å¼€ã€‚
  ERR_IMAGE_UPLOAD_FAILED_NOTIMAGE(6031),

  /// æ–‡ä»¶ä¼ è¾“ä¸‹è½½å¤±è´¥ï¼Œè¯·æ£€æŸ¥ç½‘ç»œï¼Œæˆ–è€…æ–‡ä»¶ã€è¯­éŸ³æ˜¯å¦å·²ç»è¿‡æœŸï¼Œç›®å‰èµ„æºæ–‡ä»¶å­˜å‚¨7å¤©ã€‚
  ERR_FILE_TRANS_DOWNLOAD_FAILED(6009),

  /// HTTP è¯·æ±‚å¤±è´¥ï¼Œè¯·æ£€æŸ¥ URL åœ°å€æ˜¯å¦åˆæ³•ï¼Œå¯åœ¨ç½‘é¡µæµè§ˆå™¨å°è¯•è®¿é—®è¯¥ URL åœ°å€ã€‚
  ERR_HTTP_REQ_FAILED(6010),

  /// IM SDK æ— æ•ˆæ¶ˆæ¯ elemï¼Œå…·ä½“å¯æŸ¥çœ‹é”™è¯¯ä¿¡æ¯è¿›ä¸€æ­¥å®šä¹‰å“ªä¸ªå­—æ®µã€‚
  ERR_INVALID_MSG_ELEM(6016),

  /// æ— æ•ˆçš„å¯¹è±¡ï¼Œä¾‹å¦‚ç”¨æˆ·è‡ªå·±ç”Ÿæˆ TIMImage å¯¹è±¡ï¼Œæˆ–å†…éƒ¨èµ‹å€¼é”™è¯¯å¯¼è‡´å¯¹è±¡æ— æ•ˆã€‚
  ERR_INVALID_SDK_OBJECT(6021),

  /// æ— æ•ˆçš„æ¶ˆæ¯æŽ¥æ”¶æ–¹ï¼Œè¯·åœ¨ IM æŽ§åˆ¶å°æ£€æŸ¥æ¶ˆæ¯çš„æŽ¥æ”¶æ–¹æ˜¯å¦å­˜åœ¨ã€‚
  ERR_INVALID_MSG_RECEIVER(6032),

  /// æ¶ˆæ¯é•¿åº¦è¶…å‡ºé™åˆ¶ï¼Œæ¶ˆæ¯é•¿åº¦ä¸è¦è¶…è¿‡12kï¼Œæ¶ˆæ¯é•¿åº¦æ˜¯å„ä¸ª elem é•¿åº¦çš„æ€»å’Œï¼Œelem é•¿åº¦æ˜¯æ‰€æœ‰ elem å­—æ®µçš„é•¿åº¦æ€»å’Œã€‚
  ERR_SDK_MSG_BODY_SIZE_LIMIT(8001),

  /// æ¶ˆæ¯ KEY é”™è¯¯ï¼Œå†…éƒ¨é”™è¯¯ï¼Œç½‘ç»œè¯·æ±‚åŒ…çš„ KEY å’Œ å›žå¤åŒ…çš„ä¸ä¸€è‡´ã€‚
  ERR_SDK_MSG_KEY_REQ_DIFFER_RSP(8002),

  /// ä¸‡è±¡ä¼˜å›¾ HTTP è¯·æ±‚å¤±è´¥ã€‚
  ERR_SDK_IMAGE_CONVERT_ERROR(8003),

  /// ä¸‡è±¡ä¼˜å›¾å› ä¸ºé‰´é»„ç­‰åŽŸå› è½¬ç¼©ç•¥å›¾å¤±è´¥ã€‚
  ERR_SDK_IMAGE_CI_BLOCK(8004),

  /// åˆå¹¶æ¶ˆæ¯åµŒå¥—å±‚æ•°è¶…è¿‡ä¸Šé™ï¼ˆä¸Šé™ 100 å±‚ï¼‰ã€‚
  ERR_MERGER_MSG_LAYERS_OVER_LIMIT(8005),

  /// æ¶ˆæ¯ä¿®æ”¹å†²çªï¼Œæ‚¨è¯·æ±‚ä¿®æ”¹çš„æ¶ˆæ¯å·²ç»è¢«å…¶ä»–äººä¿®æ”¹ã€‚
  ERR_SDK_MSG_MODIFY_CONFLICT(8006),

  /// ä¿¡ä»¤è¯·æ±‚ ID æ— æ•ˆæˆ–å·²ç»è¢«å¤„ç†è¿‡ã€‚ï¼ˆä¸Šå±‚æŽ¥å£ä½¿ç”¨ï¼Œåº•å±‚ä¸ºäº†ä¸é‡å¤ä¹Ÿå¢žåŠ ä¸€ä»½ï¼‰
  ERR_SDK_SIGNALING_INVALID_INVITE_ID(8010),

  /// ä¿¡ä»¤è¯·æ±‚æ— æƒé™ï¼Œæ¯”å¦‚å–æ¶ˆéžè‡ªå·±å‘èµ·çš„é‚€è¯·ã€‚ï¼ˆä¸Šå±‚æŽ¥å£ä½¿ç”¨ï¼Œåº•å±‚ä¸ºäº†ä¸é‡å¤ä¹Ÿå¢žåŠ ä¸€ä»½ï¼‰
  ERR_SDK_SIGNALING_NO_PERMISSION(8011),

  /// å–æ¶ˆæ¶ˆæ¯æ—¶ï¼Œå–æ¶ˆçš„æ¶ˆæ¯ä¸å­˜åœ¨ï¼Œæˆ–è€…å·²ç»å‘é€æˆåŠŸã€‚å–æ¶ˆå¤±è´¥
  ERR_SDK_INVALID_CANCEL_MESSAGE(8020),

  /// æ¶ˆæ¯å‘é€å¤±è´¥ï¼Œå› ä¸ºè¯¥æ¶ˆæ¯å·²è¢«å–æ¶ˆ
  ERR_SDK_SEND_MESSAGE_FAILED_WITH_CANCEL(8021),

  /// ç¾¤ç»„ ID éžæ³•ï¼Œè‡ªå®šä¹‰ç¾¤ç»„ ID å¿…é¡»ä¸ºå¯æ‰“å° ASCII å­—ç¬¦ï¼ˆ0x20-0x7eï¼‰ï¼Œæœ€é•¿48ä¸ªå­—èŠ‚ï¼Œä¸”å‰ç¼€ä¸èƒ½ä¸º @TGS#ï¼ˆé¿å…ä¸ŽæœåŠ¡ç«¯é»˜è®¤åˆ†é…çš„ç¾¤ç»„ ID æ··æ·†ï¼‰ã€‚
  ERR_SDK_GROUP_INVALID_ID(8501),

  /// ç¾¤åç§°éžæ³•ï¼Œç¾¤åç§°æœ€é•¿30å­—èŠ‚ï¼Œå­—ç¬¦ç¼–ç å¿…é¡»æ˜¯ UTF-8 ï¼Œå¦‚æžœåŒ…å«ä¸­æ–‡ï¼Œå¯èƒ½ç”¨å¤šä¸ªå­—èŠ‚è¡¨ç¤ºä¸€ä¸ªä¸­æ–‡å­—ç¬¦ï¼Œè¯·æ³¨æ„æ£€æŸ¥å­—ç¬¦ä¸²çš„å­—èŠ‚é•¿åº¦ã€‚
  ERR_SDK_GROUP_INVALID_NAME(8502),

  /// ç¾¤ç®€ä»‹éžæ³•ï¼Œç¾¤ç®€ä»‹æœ€é•¿240å­—èŠ‚ï¼Œå­—ç¬¦ç¼–ç å¿…é¡»æ˜¯ UTF-8 ï¼Œå¦‚æžœåŒ…å«ä¸­æ–‡ï¼Œå¯èƒ½ç”¨å¤šä¸ªå­—èŠ‚è¡¨ç¤ºä¸€ä¸ªä¸­æ–‡å­—ç¬¦ï¼Œè¯·æ³¨æ„æ£€æŸ¥å­—ç¬¦ä¸²çš„å­—èŠ‚é•¿åº¦ã€‚
  ERR_SDK_GROUP_INVALID_INTRODUCTION(8503),

  /// ç¾¤å…¬å‘Šéžæ³•ï¼Œç¾¤å…¬å‘Šæœ€é•¿300å­—èŠ‚ï¼Œå­—ç¬¦ç¼–ç å¿…é¡»æ˜¯ UTF-8 ï¼Œå¦‚æžœåŒ…å«ä¸­æ–‡ï¼Œå¯èƒ½ç”¨å¤šä¸ªå­—èŠ‚è¡¨ç¤ºä¸€ä¸ªä¸­æ–‡å­—ç¬¦ï¼Œè¯·æ³¨æ„æ£€æŸ¥å­—ç¬¦ä¸²çš„å­—èŠ‚é•¿åº¦ã€‚
  ERR_SDK_GROUP_INVALID_NOTIFICATION(8504),

  /// ç¾¤å¤´åƒ URL éžæ³•ï¼Œç¾¤å¤´åƒ URL æœ€é•¿100å­—èŠ‚ï¼Œå¯åœ¨ç½‘é¡µæµè§ˆå™¨å°è¯•è®¿é—®è¯¥ URL åœ°å€ã€‚
  ERR_SDK_GROUP_INVALID_FACE_URL(8505),

  /// ç¾¤åç‰‡éžæ³•ï¼Œç¾¤åç‰‡æœ€é•¿50å­—èŠ‚ï¼Œå­—ç¬¦ç¼–ç å¿…é¡»æ˜¯ UTF-8 ï¼Œå¦‚æžœåŒ…å«ä¸­æ–‡ï¼Œå¯èƒ½ç”¨å¤šä¸ªå­—èŠ‚è¡¨ç¤ºä¸€ä¸ªä¸­æ–‡å­—ç¬¦ï¼Œè¯·æ³¨æ„æ£€æŸ¥å­—ç¬¦ä¸²çš„å­—èŠ‚é•¿åº¦ã€‚
  ERR_SDK_GROUP_INVALID_NAME_CARD(8506),

  /// è¶…è¿‡ç¾¤ç»„æˆå‘˜æ•°çš„é™åˆ¶ï¼Œåœ¨åˆ›å»ºç¾¤å’Œé‚€è¯·æˆå‘˜æ—¶ï¼ŒæŒ‡å®šçš„æˆå‘˜æ•°è¶…å‡ºé™åˆ¶ï¼Œæœ€å¤§ç¾¤æˆå‘˜æ•°é‡ï¼šç§æœ‰ç¾¤æ˜¯200äººï¼Œå…¬å¼€ç¾¤æ˜¯2000äººï¼ŒèŠå¤©å®¤æ˜¯10000äººï¼ŒéŸ³è§†é¢‘èŠå¤©å®¤å’Œåœ¨çº¿æˆå‘˜å¹¿æ’­å¤§ç¾¤æ— é™åˆ¶ã€‚
  ERR_SDK_GROUP_MEMBER_COUNT_LIMIT(8507),

  /// ä¸å…è®¸ç”³è¯·åŠ å…¥ Private ç¾¤ç»„ï¼Œä»»æ„ç¾¤æˆå‘˜å¯é‚€è¯·å…¥ç¾¤ï¼Œä¸”æ— éœ€è¢«é‚€è¯·äººåŒæ„ã€‚
  ERR_SDK_GROUP_JOIN_PRIVATE_GROUP_DENY(8508),

  /// ä¸å…è®¸é‚€è¯·è§’è‰²ä¸ºç¾¤ä¸»çš„æˆå‘˜ï¼Œè¯·æ£€æŸ¥è§’è‰²å­—æ®µæ˜¯å¦å¡«å†™æ­£ç¡®ã€‚
  ERR_SDK_GROUP_INVITE_SUPER_DENY(8509),

  /// ä¸å…è®¸é‚€è¯·0ä¸ªæˆå‘˜ï¼Œè¯·æ£€æŸ¥æˆå‘˜å­—æ®µæ˜¯å¦å¡«å†™æ­£ç¡®ã€‚
  ERR_SDK_GROUP_INVITE_NO_MEMBER(8510),

  /// ç¾¤å±žæ€§æŽ¥å£æ“ä½œé™åˆ¶ï¼šå¢žåˆ æ”¹æŽ¥å£åŽå°é™åˆ¶1ç§’5æ¬¡ï¼ŒæŸ¥æŽ¥å£ SDK é™åˆ¶5ç§’20æ¬¡ã€‚
  ERR_SDK_GROUP_ATTR_FREQUENCY_LIMIT(8511),

  /// èŽ·å–ç¾¤åœ¨çº¿äººæ•°æŽ¥å£æ“ä½œé™åˆ¶ï¼šæŸ¥æŽ¥å£ SDK é™åˆ¶60ç§’1æ¬¡ã€‚
  ERR_SDK_GROUP_GET_ONLINE_MEMBER_COUNT_LIMIT(8512),

  /// èŽ·å–ç¾¤èµ„æ–™æŽ¥å£æ“ä½œé™åˆ¶ï¼šæŸ¥æŽ¥å£ SDK é™åˆ¶1ç§’1æ¬¡ã€‚
  ERR_SDK_GROUP_GET_GROUPS_INFO_LIMIT(8513),

  /// èŽ·å–åŠ å…¥ç¾¤åˆ—è¡¨æŽ¥å£æ“ä½œé™åˆ¶ï¼šæŸ¥æŽ¥å£ SDK é™åˆ¶1ç§’1æ¬¡ã€‚
  ERR_SDK_GROUP_GET_JOINED_GROUP_LIMIT(8514),

  /// èµ„æ–™å­—æ®µéžæ³•ï¼Œèµ„æ–™æ”¯æŒæ ‡é…å­—æ®µåŠè‡ªå®šä¹‰å­—æ®µï¼Œå…¶ä¸­è‡ªå®šä¹‰å­—æ®µçš„å…³é”®å­—ï¼Œå¿…é¡»æ˜¯è‹±æ–‡å­—æ¯ï¼Œä¸”é•¿åº¦ä¸å¾—è¶…è¿‡8å­—èŠ‚ï¼Œè‡ªå®šä¹‰å­—æ®µçš„å€¼æœ€é•¿ä¸èƒ½è¶…è¿‡500å­—èŠ‚ã€‚
  ERR_SDK_FRIENDSHIP_INVALID_PROFILE_KEY(9001),

  /// å¤‡æ³¨å­—æ®µéžæ³•ï¼Œæœ€å¤§96å­—èŠ‚ï¼Œå­—ç¬¦ç¼–ç å¿…é¡»æ˜¯ UTF-8 ï¼Œå¦‚æžœåŒ…å«ä¸­æ–‡ï¼Œå¯èƒ½ç”¨å¤šä¸ªå­—èŠ‚è¡¨ç¤ºä¸€ä¸ªä¸­æ–‡å­—ç¬¦ï¼Œè¯·æ³¨æ„æ£€æŸ¥å­—ç¬¦ä¸²çš„å­—èŠ‚é•¿åº¦ã€‚
  ERR_SDK_FRIENDSHIP_INVALID_ADD_REMARK(9002),

  /// è¯·æ±‚æ·»åŠ å¥½å‹çš„è¯·æ±‚è¯´æ˜Žå­—æ®µéžæ³•ï¼Œæœ€å¤§120å­—èŠ‚ï¼Œå­—ç¬¦ç¼–ç å¿…é¡»æ˜¯ UTF-8 ï¼Œå¦‚æžœåŒ…å«ä¸­æ–‡ï¼Œå¯èƒ½ç”¨å¤šä¸ªå­—èŠ‚è¡¨ç¤ºä¸€ä¸ªä¸­æ–‡å­—ç¬¦ï¼Œè¯·æ³¨æ„æ£€æŸ¥å­—ç¬¦ä¸²çš„å­—èŠ‚é•¿åº¦ã€‚
  ERR_SDK_FRIENDSHIP_INVALID_ADD_WORDING(9003),

  /// è¯·æ±‚æ·»åŠ å¥½å‹çš„æ·»åŠ æ¥æºå­—æ®µéžæ³•ï¼Œæ¥æºéœ€è¦æ·»åŠ â€œAddSource_Type_â€å‰ç¼€ã€‚
  ERR_SDK_FRIENDSHIP_INVALID_ADD_SOURCE(9004),

  /// å¥½å‹åˆ†ç»„å­—æ®µéžæ³•ï¼Œå¿…é¡»ä¸ä¸ºç©ºï¼Œæ¯ä¸ªåˆ†ç»„çš„åç§°æœ€é•¿30å­—èŠ‚ï¼Œå­—ç¬¦ç¼–ç å¿…é¡»æ˜¯ UTF-8 ï¼Œå¦‚æžœåŒ…å«ä¸­æ–‡ï¼Œå¯èƒ½ç”¨å¤šä¸ªå­—èŠ‚è¡¨ç¤ºä¸€ä¸ªä¸­æ–‡å­—ç¬¦ï¼Œè¯·æ³¨æ„æ£€æŸ¥å­—ç¬¦ä¸²çš„å­—èŠ‚é•¿åº¦ã€‚
  ERR_SDK_FRIENDSHIP_FRIEND_GROUP_EMPTY(9005),

  /// è¶…è¿‡æ•°é‡é™åˆ¶
  ERR_SDK_FRIENDSHIP_EXCEED_THE_LIMIT(9006),

  /// ç½‘ç»œåŠ å¯†å¤±è´¥ï¼Œå†…éƒ¨é”™è¯¯ã€‚
  ERR_SDK_NET_ENCODE_FAILED(9501),

  /// ç½‘ç»œæ•°æ®è§£å¯†å¤±è´¥ï¼Œå†…éƒ¨é”™è¯¯ã€‚
  ERR_SDK_NET_DECODE_FAILED(9502),

  /// æœªå®Œæˆé‰´æƒï¼Œå¯èƒ½ç™»å½•æœªå®Œæˆï¼Œè¯·åœ¨ç™»å½•å®ŒæˆåŽå†æ“ä½œã€‚
  ERR_SDK_NET_AUTH_INVALID(9503),

  /// æ•°æ®åŒ…åŽ‹ç¼©å¤±è´¥ï¼Œå†…éƒ¨é”™è¯¯ã€‚
  ERR_SDK_NET_COMPRESS_FAILED(9504),

  /// æ•°æ®åŒ…è§£åŽ‹å¤±è´¥ï¼Œå†…éƒ¨é”™è¯¯ã€‚
  ERR_SDK_NET_UNCOMPRESS_FAILED(9505),

  /// è°ƒç”¨é¢‘çŽ‡é™åˆ¶ï¼Œæœ€å¤§æ¯ç§’å‘èµ· 5 æ¬¡è¯·æ±‚ã€‚
  ERR_SDK_NET_FREQ_LIMIT(9506),

  /// è¯·æ±‚é˜Ÿåˆ—æº€ï¼Œè¶…è¿‡åŒæ—¶è¯·æ±‚çš„æ•°é‡é™åˆ¶ï¼Œæœ€å¤§åŒæ—¶å‘èµ·1000ä¸ªè¯·æ±‚ã€‚
  ERR_SDK_NET_REQ_COUNT_LIMIT(9507),

  /// ç½‘ç»œå·²æ–­å¼€ï¼Œæœªå»ºç«‹è¿žæŽ¥ï¼Œæˆ–è€…å»ºç«‹ socket è¿žæŽ¥æ—¶ï¼Œæ£€æµ‹åˆ°æ— ç½‘ç»œã€‚
  ERR_SDK_NET_DISCONNECT(9508),

  /// ç½‘ç»œè¿žæŽ¥å·²å»ºç«‹ï¼Œé‡å¤åˆ›å»ºè¿žæŽ¥ï¼Œå†…éƒ¨é”™è¯¯ã€‚
  ERR_SDK_NET_ALLREADY_CONN(9509),

  /// å»ºç«‹ç½‘ç»œè¿žæŽ¥è¶…æ—¶ï¼Œè¯·ç­‰ç½‘ç»œæ¢å¤åŽé‡è¯•ã€‚
  ERR_SDK_NET_CONN_TIMEOUT(9510),

  /// ç½‘ç»œè¿žæŽ¥å·²è¢«æ‹’ç»ï¼Œè¯·æ±‚è¿‡äºŽé¢‘ç¹ï¼ŒæœåŠ¡ç«¯æ‹’ç»æœåŠ¡ã€‚
  ERR_SDK_NET_CONN_REFUSE(9511),

  /// æ²¡æœ‰åˆ°è¾¾ç½‘ç»œçš„å¯ç”¨è·¯ç”±ï¼Œè¯·ç­‰ç½‘ç»œæ¢å¤åŽé‡è¯•ã€‚
  ERR_SDK_NET_NET_UNREACH(9512),

  /// ç³»ç»Ÿä¸­æ²¡æœ‰è¶³å¤Ÿçš„ç¼“å†²åŒºç©ºé—´èµ„æºå¯ç”¨æ¥å®Œæˆè°ƒç”¨ï¼Œç³»ç»Ÿè¿‡äºŽç¹å¿™ï¼Œå†…éƒ¨é”™è¯¯ã€‚
  ERR_SDK_NET_SOCKET_NO_BUFF(9513),

  /// å¯¹ç«¯é‡ç½®äº†è¿žæŽ¥ï¼Œå¯èƒ½æœåŠ¡ç«¯è¿‡è½½ï¼ŒSDK å†…éƒ¨ä¼šè‡ªåŠ¨é‡è¿žï¼Œè¯·ç­‰ç½‘ç»œè¿žæŽ¥æˆåŠŸ onConnSucc ï¼ˆ iOS ï¼‰ æˆ– onConnected ï¼ˆ Android ï¼‰ å›žè°ƒåŽé‡è¯•ã€‚
  ERR_SDK_NET_RESET_BY_PEER(9514),

  /// socket å¥—æŽ¥å­—æ— æ•ˆï¼Œå†…éƒ¨é”™è¯¯ã€‚
  ERR_SDK_NET_SOCKET_INVALID(9515),

  /// IP åœ°å€è§£æžå¤±è´¥ï¼Œå†…éƒ¨é”™è¯¯ï¼Œå¯èƒ½æ˜¯æœ¬åœ° imsdk_config é…ç½®æ–‡ä»¶è¢«æŸåï¼Œè¯»å–åˆ°åˆ° IP åœ°å€éžæ³•ã€‚
  ERR_SDK_NET_HOST_GETADDRINFO_FAILED(9516),

  /// ç½‘ç»œè¿žæŽ¥åˆ°ä¸­é—´èŠ‚ç‚¹æˆ–æœåŠ¡ç«¯é‡ç½®ï¼Œå¼•èµ·è¿žæŽ¥å¤±æ•ˆï¼Œå†…éƒ¨é”™è¯¯ï¼ŒSDK å†…éƒ¨ä¼šè‡ªåŠ¨é‡è¿žï¼Œè¯·ç­‰ç½‘ç»œè¿žæŽ¥æˆåŠŸ onConnSucc ï¼ˆ iOS ï¼‰ æˆ– onConnected ï¼ˆ Android ï¼‰ å›žè°ƒåŽé‡è¯•ã€‚
  ERR_SDK_NET_CONNECT_RESET(9517),

  /// è¯·æ±‚åŒ…ç­‰å¾…è¿›å…¥å¾…å‘é€é˜Ÿåˆ—è¶…æ—¶ï¼Œå‘é€æ—¶ç½‘ç»œè¿žæŽ¥å»ºç«‹æ¯”è¾ƒæ…¢ æˆ– é¢‘ç¹æ–­ç½‘é‡è¿žæ—¶ï¼Œä¼šå‡ºçŽ°è¯¥é”™è¯¯ï¼Œè¯·æ£€æŸ¥ç½‘ç»œè¿žæŽ¥æ˜¯å¦æ­£å¸¸ã€‚
  ERR_SDK_NET_WAIT_INQUEUE_TIMEOUT(9518),

  /// è¯·æ±‚åŒ…å·²è¿›å…¥ IM SDK å¾…å‘é€é˜Ÿåˆ—ï¼Œç­‰å¾…è¿›å…¥æ“ä½œç³»ç»Ÿçš„ç½‘ç»œå±‚æ—¶è¶…æ—¶ã€‚ä¸€èˆ¬å¯èƒ½åŽŸå› æ˜¯æœ¬åœ°ç½‘ç»œå—é™/ä¸é€šæˆ–æœ¬åœ°ç½‘ç»œä¸Ž IM SDK åŽå°è¿žæŽ¥ä¸é€šã€‚å»ºè®®ç”¨ä¸åŒçš„ç½‘ç»œçŽ¯å¢ƒåˆ†åˆ«è¿è¡Œ IM SDK æ¥ç¡®è®¤æ˜¯å¦å› å½“å‰ç½‘ç»œçŽ¯å¢ƒé—®é¢˜å¼•èµ·ã€‚
  ERR_SDK_NET_WAIT_SEND_TIMEOUT(9519),

  /// è¯·æ±‚åŒ…å·²ç”± IM SDK å¾…å‘é€é˜Ÿåˆ—è¿›å…¥æ“ä½œç³»ç»Ÿç½‘ç»œå±‚ï¼Œç­‰å¾…æœåŠ¡ç«¯å›žåŒ…è¶…æ—¶ã€‚ä¸€èˆ¬å¯èƒ½åŽŸå› æ˜¯æœ¬åœ°ç½‘ç»œå—é™/ä¸é€šæˆ–æœ¬åœ°ç½‘ç»œä¸Ž IM SDK åŽå°è¿žæŽ¥ä¸é€šã€‚å»ºè®®ç”¨ä¸åŒçš„ç½‘ç»œçŽ¯å¢ƒåˆ†åˆ«è¿è¡Œ IM SDK æ¥ç¡®è®¤æ˜¯å¦å› å½“å‰ç½‘ç»œçŽ¯å¢ƒé—®é¢˜å¼•èµ·ã€‚
  ERR_SDK_NET_WAIT_ACK_TIMEOUT(9520),

  /// è¯·æ±‚åŒ…å·²è¿›å…¥å¾…å‘é€é˜Ÿåˆ—ï¼Œéƒ¨åˆ†æ•°æ®å·²å‘é€ï¼Œç­‰å¾…å‘é€å‰©ä½™éƒ¨åˆ†å‡ºçŽ°è¶…æ—¶ï¼Œå¯èƒ½ä¸Šè¡Œå¸¦å®½ä¸è¶³ï¼Œè¯·æ£€æŸ¥ç½‘ç»œæ˜¯å¦ç•…é€šï¼Œåœ¨å›žè°ƒé”™è¯¯æ—¶æ£€æµ‹æœ‰è”ç½‘ï¼Œå†…éƒ¨é”™è¯¯ã€‚
  ERR_SDK_NET_WAIT_SEND_REMAINING_TIMEOUT(9521),

  /// è¯·æ±‚åŒ…é•¿åº¦å¤§äºŽé™åˆ¶ï¼Œæœ€å¤§æ”¯æŒ 1MB ã€‚
  ERR_SDK_NET_PKG_SIZE_LIMIT(9522),

  /// è¯·æ±‚åŒ…å·²è¿›å…¥å¾…å‘é€é˜Ÿåˆ—ï¼Œç­‰å¾…è¿›å…¥ç³»ç»Ÿçš„ç½‘ç»œ buffer è¶…æ—¶ï¼Œæ•°æ®åŒ…è¾ƒå¤š æˆ– å‘é€çº¿ç¨‹å¤„ç†ä¸è¿‡æ¥ï¼Œåœ¨å›žè°ƒé”™è¯¯ç æ—¶æ£€æµ‹åˆ°æ²¡æœ‰è”ç½‘ã€‚
  ERR_SDK_NET_WAIT_SEND_TIMEOUT_NO_NETWORK(9523),

  /// è¯·æ±‚åŒ…å·²è¿›å…¥ç³»ç»Ÿçš„ç½‘ç»œ buffer ï¼Œç­‰å¾…æœåŠ¡ç«¯å›žåŒ…è¶…æ—¶ï¼Œå¯èƒ½è¯·æ±‚åŒ…æ²¡ç¦»å¼€ç»ˆç«¯è®¾å¤‡ã€ä¸­é—´è·¯ç”±ä¸¢å¼ƒã€æœåŠ¡ç«¯æ„å¤–ä¸¢åŒ…æˆ–å›žåŒ…è¢«ç³»ç»Ÿç½‘ç»œå±‚ä¸¢å¼ƒï¼Œåœ¨å›žè°ƒé”™è¯¯ç æ—¶æ£€æµ‹åˆ°æ²¡æœ‰è”ç½‘ã€‚
  ERR_SDK_NET_WAIT_ACK_TIMEOUT_NO_NETWORK(9524),

  /// è¯·æ±‚åŒ…å·²è¿›å…¥å¾…å‘é€é˜Ÿåˆ—ï¼Œéƒ¨åˆ†æ•°æ®å·²å‘é€ï¼Œç­‰å¾…å‘é€å‰©ä½™éƒ¨åˆ†å‡ºçŽ°è¶…æ—¶ï¼Œå¯èƒ½ä¸Šè¡Œå¸¦å®½ä¸è¶³ï¼Œè¯·æ£€æŸ¥ç½‘ç»œæ˜¯å¦ç•…é€šï¼Œåœ¨å›žè°ƒé”™è¯¯ç æ—¶æ£€æµ‹åˆ°æ²¡æœ‰è”ç½‘ã€‚
  ERR_SDK_NET_SEND_REMAINING_TIMEOUT_NO_NETWORK(9525),

  /// Server çš„è¿žæŽ¥æ•°é‡è¶…å‡ºé™åˆ¶ï¼ŒæœåŠ¡ç«¯æ‹’ç»æœåŠ¡ã€‚
  ERR_SVR_SSO_CONNECT_LIMIT(-302),

  /// ä¸‹å‘éªŒè¯ç æ ‡å¿—é”™è¯¯ã€‚
  ERR_SVR_SSO_VCODE(-10000),

  /// Key è¿‡æœŸã€‚Key æ˜¯æ ¹æ® UserSig ç”Ÿæˆçš„å†…éƒ¨ç¥¨æ®ï¼ŒKey çš„æœ‰æ•ˆæœŸå°äºŽæˆ–ç­‰äºŽ UserSig çš„æœ‰æ•ˆæœŸã€‚è¯·é‡æ–°è°ƒç”¨ V2TIMManager.getInstance().login ç™»å½•æŽ¥å£ç”Ÿæˆæ–°çš„ Keyã€‚
  ERR_SVR_SSO_D2_EXPIRED(-10001),

  /// Ticket è¿‡æœŸã€‚Ticket æ˜¯æ ¹æ® UserSig ç”Ÿæˆçš„å†…éƒ¨ç¥¨æ®ï¼ŒTicket çš„æœ‰æ•ˆæœŸå°äºŽæˆ–ç­‰äºŽ UserSig çš„æœ‰æ•ˆæœŸã€‚è¯·é‡æ–°è°ƒç”¨ V2TIMManager.getInstance().login ç™»å½•æŽ¥å£ç”Ÿæˆæ–°çš„ Ticketã€‚
  ERR_SVR_SSO_A2_UP_INVALID(-10003),

  /// ç¥¨æ®éªŒè¯æ²¡é€šè¿‡æˆ–è€…è¢«å®‰å…¨æ‰“å‡»ã€‚è¯·é‡æ–°è°ƒç”¨ V2TIMManager.getInstance().login ç™»å½•æŽ¥å£ç”Ÿæˆæ–°çš„ç¥¨æ®ã€‚
  ERR_SVR_SSO_A2_DOWN_INVALID(-10004),

  /// ä¸å…è®¸ç©º Keyã€‚
  ERR_SVR_SSO_EMPTY_KEY(-10005),

  /// Key ä¸­çš„è´¦å·å’Œè¯·æ±‚åŒ…å¤´çš„è´¦å·ä¸åŒ¹é…ã€‚
  ERR_SVR_SSO_UIN_INVALID(-10006),

  /// éªŒè¯ç ä¸‹å‘è¶…æ—¶ã€‚
  ERR_SVR_SSO_VCODE_TIMEOUT(-10007),

  /// éœ€è¦å¸¦ä¸Š Key å’Œ Ticketã€‚
  ERR_SVR_SSO_NO_IMEI_AND_A2(-10008),

  /// Cookie æ£€æŸ¥ä¸åŒ¹é…ã€‚
  ERR_SVR_SSO_COOKIE_INVALID(-10009),

  /// ä¸‹å‘æç¤ºè¯­æ—¶ Key è¿‡æœŸã€‚Key æ˜¯æ ¹æ® UserSig ç”Ÿæˆçš„å†…éƒ¨ç¥¨æ®ï¼ŒKey çš„æœ‰æ•ˆæœŸå°äºŽæˆ–ç­‰äºŽ UserSig çš„æœ‰æ•ˆæœŸã€‚è¯·é‡æ–°è°ƒç”¨ V2TIMManager.getInstance().login ç™»å½•æŽ¥å£ç”Ÿæˆæ–°çš„ Keyã€‚
  ERR_SVR_SSO_DOWN_TIP(-10101),

  /// ç½‘ç»œè¿žæŽ¥æ–­å¼€ã€‚
  ERR_SVR_SSO_DISCONNECT(-10102),

  /// å¤±æ•ˆèº«ä»½ã€‚
  ERR_SVR_SSO_IDENTIFIER_INVALID(-10103),

  /// ç»ˆç«¯è‡ªåŠ¨é€€å‡ºã€‚
  ERR_SVR_SSO_CLIENT_CLOSE(-10104),

  /// MSFSDK è‡ªåŠ¨é€€å‡ºã€‚
  ERR_SVR_SSO_MSFSDK_QUIT(-10105),

  /// è§£å¯†å¤±è´¥æ¬¡æ•°è¶…è¿‡é˜ˆå€¼ï¼Œé€šçŸ¥ç»ˆç«¯éœ€è¦é‡ç½®ï¼Œè¯·é‡æ–°è°ƒç”¨ TIMManager.getInstance().login ç™»å½•æŽ¥å£ç”Ÿæˆæ–°çš„ Keyã€‚
  ERR_SVR_SSO_D2KEY_WRONG(-10106),

  /// ä¸æ”¯æŒèšåˆï¼Œç»™ç»ˆç«¯è¿”å›žç»Ÿä¸€çš„é”™è¯¯ç ã€‚ç»ˆç«¯åœ¨è¯¥ TCP é•¿è¿žæŽ¥ä¸Šåœæ­¢èšåˆã€‚
  ERR_SVR_SSO_UNSURPPORT(-10107),

  /// é¢„ä»˜è´¹æ¬ è´¹ã€‚
  ERR_SVR_SSO_PREPAID_ARREARS(-10108),

  /// è¯·æ±‚åŒ…æ ¼å¼é”™è¯¯ã€‚
  ERR_SVR_SSO_PACKET_WRONG(-10109),

  /// SDKAppID é»‘åå•ã€‚
  ERR_SVR_SSO_APPID_BLACK_LIST(-10110),

  /// SDKAppID è®¾ç½® service cmd é»‘åå•ã€‚
  ERR_SVR_SSO_CMD_BLACK_LIST(-10111),

  /// SDKAppID åœç”¨ã€‚
  ERR_SVR_SSO_APPID_WITHOUT_USING(-10112),

  /// é¢‘çŽ‡é™åˆ¶(ç”¨æˆ·)ï¼Œé¢‘çŽ‡é™åˆ¶æ˜¯è®¾ç½®é’ˆå¯¹æŸä¸€ä¸ªåè®®çš„æ¯ç§’è¯·æ±‚æ•°çš„é™åˆ¶ã€‚
  ERR_SVR_SSO_FREQ_LIMIT(-10113),

  /// è¿‡è½½ä¸¢åŒ…(ç³»ç»Ÿ)ï¼Œè¿žæŽ¥çš„æœåŠ¡ç«¯å¤„ç†è¿‡å¤šè¯·æ±‚ï¼Œå¤„ç†ä¸è¿‡æ¥ï¼Œæ‹’ç»æœåŠ¡ã€‚
  ERR_SVR_SSO_OVERLOAD(-10114),

  /// ç»ˆç«¯è®¿é—®æŽ¥å£è¶…é¢‘ã€‚
  ERR_SVR_SSO_FREQUENCY_LIMIT(-20009),

  /// è¦å‘é€çš„èµ„æºæ–‡ä»¶ä¸å­˜åœ¨ã€‚
  ERR_SVR_RES_NOT_FOUND(114000),

  /// è¦å‘é€çš„èµ„æºæ–‡ä»¶ä¸å…è®¸è®¿é—®ã€‚
  ERR_SVR_RES_ACCESS_DENY(114001),

  /// æ–‡ä»¶å¤§å°è¶…è¿‡é™åˆ¶ã€‚
  ERR_SVR_RES_SIZE_LIMIT(114002),

  /// ç”¨æˆ·å–æ¶ˆå‘é€ï¼Œå¦‚å‘é€è¿‡ç¨‹ä¸­ç™»å‡ºç­‰åŽŸå› ã€‚
  ERR_SVR_RES_SEND_CANCEL(114003),

  /// è¯»å–æ–‡ä»¶å†…å®¹å¤±è´¥ã€‚
  ERR_SVR_RES_READ_FAILED(114004),

  /// èµ„æºæ–‡ä»¶ï¼ˆå¦‚å›¾ç‰‡ã€æ–‡ä»¶ã€è¯­éŸ³ã€è§†é¢‘ï¼‰ä¼ è¾“è¶…æ—¶ï¼Œä¸€èˆ¬æ˜¯ç½‘ç»œé—®é¢˜å¯¼è‡´ã€‚
  ERR_SVR_RES_TRANSFER_TIMEOUT(114005),

  /// å‚æ•°éžæ³•ã€‚
  ERR_SVR_RES_INVALID_PARAMETERS(114011),

  /// æ–‡ä»¶ MD5 æ ¡éªŒå¤±è´¥ã€‚
  ERR_SVR_RES_INVALID_FILE_MD5(115066),

  /// åˆ†ç‰‡ MD5 æ ¡éªŒå¤±è´¥ã€‚
  ERR_SVR_RES_INVALID_PART_MD5(115068),

  /// HTTP è§£æžé”™è¯¯ ï¼Œè¯·æ£€æŸ¥ HTTP è¯·æ±‚ URL æ ¼å¼ã€‚
  ERR_SVR_COMM_INVALID_HTTP_URL(60002),

  /// HTTP è¯·æ±‚ JSON è§£æžé”™è¯¯ï¼Œè¯·æ£€æŸ¥ JSON æ ¼å¼ã€‚
  ERR_SVR_COMM_REQ_JSON_PARSE_FAILED(60003),

  /// è¯·æ±‚ URI æˆ– JSON åŒ…ä½“ä¸­ Identifier æˆ– UserSig é”™è¯¯ã€‚
  ERR_SVR_COMM_INVALID_ACCOUNT(60004),

  /// è¯·æ±‚ URI æˆ– JSON åŒ…ä½“ä¸­ Identifier æˆ– UserSig é”™è¯¯ã€‚
  ERR_SVR_COMM_INVALID_ACCOUNT_EX(60005),

  /// SDKAppID å¤±æ•ˆï¼Œè¯·æ ¸å¯¹ SDKAppID æœ‰æ•ˆæ€§ã€‚
  ERR_SVR_COMM_INVALID_SDKAPPID(60006),

  /// REST æŽ¥å£è°ƒç”¨é¢‘çŽ‡è¶…è¿‡é™åˆ¶ï¼Œè¯·é™ä½Žè¯·æ±‚é¢‘çŽ‡ã€‚
  ERR_SVR_COMM_REST_FREQ_LIMIT(60007),

  /// æœåŠ¡è¯·æ±‚è¶…æ—¶æˆ– HTTP è¯·æ±‚æ ¼å¼é”™è¯¯ï¼Œè¯·æ£€æŸ¥å¹¶é‡è¯•ã€‚
  ERR_SVR_COMM_REQUEST_TIMEOUT(60008),

  /// è¯·æ±‚èµ„æºé”™è¯¯ï¼Œè¯·æ£€æŸ¥è¯·æ±‚ URLã€‚
  ERR_SVR_COMM_INVALID_RES(60009),

  /// REST API è¯·æ±‚çš„ Identifier å­—æ®µè¯·å¡«å†™ App ç®¡ç†å‘˜è´¦å·ã€‚
  ERR_SVR_COMM_ID_NOT_ADMIN(60010),

  /// SDKAppID è¯·æ±‚é¢‘çŽ‡è¶…é™ï¼Œè¯·é™ä½Žè¯·æ±‚é¢‘çŽ‡ã€‚
  ERR_SVR_COMM_SDKAPPID_FREQ_LIMIT(60011),

  /// REST æŽ¥å£éœ€è¦å¸¦ SDKAppIDï¼Œè¯·æ£€æŸ¥è¯·æ±‚ URL ä¸­çš„ SDKAppIDã€‚
  ERR_SVR_COMM_SDKAPPID_MISS(60012),

  /// HTTP å“åº”åŒ… JSON è§£æžé”™è¯¯ã€‚
  ERR_SVR_COMM_RSP_JSON_PARSE_FAILED(60013),

  /// ç½®æ¢è´¦å·è¶…æ—¶ã€‚
  ERR_SVR_COMM_EXCHANGE_ACCOUNT_TIMEUT(60014),

  /// è¯·æ±‚åŒ…ä½“ Identifier ç±»åž‹é”™è¯¯ï¼Œè¯·ç¡®è®¤ Identifier ä¸ºå­—ç¬¦ä¸²æ ¼å¼ã€‚
  ERR_SVR_COMM_INVALID_ID_FORMAT(60015),

  /// SDKAppID è¢«ç¦ç”¨ï¼Œè¯· [æäº¤å·¥å•](https://console.cloud.tencent.com/workorder/category?level1_id=29&level2_id=40&source=0&data_title=%E4%BA%91%E9%80%9A%E4%BF%A1%20%20IM&step=1) è”ç³»å®¢æœç¡®è®¤ã€‚
  ERR_SVR_COMM_SDKAPPID_FORBIDDEN(60016),

  /// è¯·æ±‚è¢«ç¦ç”¨ï¼Œè¯· [æäº¤å·¥å•](https://console.cloud.tencent.com/workorder/category?level1_id=29&level2_id=40&source=0&data_title=%E4%BA%91%E9%80%9A%E4%BF%A1%20%20IM&step=1) è”ç³»å®¢æœç¡®è®¤ã€‚
  ERR_SVR_COMM_REQ_FORBIDDEN(60017),

  /// è¯·æ±‚è¿‡äºŽé¢‘ç¹ï¼Œè¯·ç¨åŽé‡è¯•ã€‚
  ERR_SVR_COMM_REQ_FREQ_LIMIT(60018),

  /// è¯·æ±‚è¿‡äºŽé¢‘ç¹ï¼Œè¯·ç¨åŽé‡è¯•ã€‚
  ERR_SVR_COMM_REQ_FREQ_LIMIT_EX(60019),

  /// æœªè´­ä¹°å¥—é¤åŒ…æˆ–è´­ä¹°çš„å¥—é¤åŒ…æ­£åœ¨é…ç½®ä¸­æš‚æœªç”Ÿæ•ˆï¼Œè¯·äº”åˆ†é’ŸåŽå†æ¬¡å°è¯•ã€‚
  ERR_SVR_COMM_INVALID_SERVICE(60020),

  /// æ–‡æœ¬å®‰å…¨æ‰“å‡»ï¼Œæ–‡æœ¬ä¸­å¯èƒ½åŒ…å«æ•æ„Ÿè¯æ±‡ã€‚
  ERR_SVR_COMM_SENSITIVE_TEXT(80001),

  /// å‘æ¶ˆæ¯åŒ…ä½“è¿‡é•¿ï¼Œç›®å‰æ”¯æŒæœ€å¤§12kæ¶ˆæ¯åŒ…ä½“é•¿åº¦ï¼Œè¯·å‡å°‘åŒ…ä½“å¤§å°é‡è¯•ã€‚
  ERR_SVR_COMM_BODY_SIZE_LIMIT(80002),

  /// å‘å•èŠæ¶ˆæ¯å‰å›žè°ƒæˆ–å‘ç¾¤èŠæ¶ˆæ¯å‰å›žè°ƒå¤±è´¥æˆ–å›žåŒ…è¶…æ—¶ï¼Œæ¶ˆæ¯ä¸ä¸‹å‘ã€‚å¯åœ¨æŽ§åˆ¶å°è‡ªåŠ©é…ç½® äº‹ä»¶å‘ç”Ÿä¹‹å‰å›žè°ƒè¶…æ—¶çš„å¤„ç†ç­–ç•¥ã€‚
  ERR_SVR_COMM_PRE_HOOK_FAILED(80003),

  /// å›¾ç‰‡å®‰å…¨æ‰“å‡»ï¼Œå›¾ç‰‡ä¸­å¯èƒ½åŒ…å«æ•æ„Ÿå†…å®¹ã€‚
  ERR_SVR_COMM_SENSITIVE_IMAGE(80004),

  /// æœåŠ¡å·²åœç”¨ï¼Œå¦‚ç‰ˆæœ¬åˆ°æœŸè¯·è´­ä¹°æˆ–ç»­è´¹å¥—é¤åŒ…ï¼Œå¦‚è´¦å·æ¬ è´¹è¯·å……å€¼ã€‚
  ERR_SVR_COMM_SERVICE_DISABLED(80005),

  /// UserSig å·²è¿‡æœŸï¼Œè¯·é‡æ–°ç”Ÿæˆ UserSigï¼Œå»ºè®® UserSig æœ‰æ•ˆæœŸä¸å°äºŽ24å°æ—¶ã€‚
  ERR_SVR_ACCOUNT_USERSIG_EXPIRED(70001),

  /// UserSig é•¿åº¦ä¸º0ï¼Œè¯·æ£€æŸ¥ä¼ å…¥çš„ UserSig æ˜¯å¦æ­£ç¡®ã€‚
  ERR_SVR_ACCOUNT_USERSIG_EMPTY(70002),

  /// UserSig æ ¡éªŒå¤±è´¥ï¼Œè¯·ç¡®è®¤ä¸‹ UserSig å†…å®¹æ˜¯å¦è¢«æˆªæ–­ï¼Œå¦‚ç¼“å†²åŒºé•¿åº¦ä¸å¤Ÿå¯¼è‡´çš„å†…å®¹æˆªæ–­ã€‚
  ERR_SVR_ACCOUNT_USERSIG_CHECK_FAILED(70003),

  /// UserSig æ ¡éªŒå¤±è´¥ï¼Œå¯ç”¨å·¥å…·è‡ªè¡ŒéªŒè¯ç”Ÿæˆçš„ UserSig æ˜¯å¦æ­£ç¡®ã€‚
  ERR_SVR_ACCOUNT_USERSIG_CHECK_FAILED_EX(70005),

  /// ç”¨å…¬é’¥éªŒè¯ UserSig å¤±è´¥ï¼Œè¯·ç¡®è®¤ç”Ÿæˆçš„ UserSig ä½¿ç”¨çš„ç§é’¥å’Œ SDKAppID æ˜¯å¦å¯¹åº”ã€‚
  ERR_SVR_ACCOUNT_USERSIG_MISMATCH_PUBLICKEY(70009),

  /// è¯·æ±‚çš„ Identifier ä¸Žç”Ÿæˆ UserSig çš„ Identifier ä¸åŒ¹é…ã€‚
  ERR_SVR_ACCOUNT_USERSIG_MISMATCH_ID(70013),

  /// è¯·æ±‚çš„ SDKAppID ä¸Žç”Ÿæˆ UserSig çš„ SDKAppID ä¸åŒ¹é…ã€‚
  ERR_SVR_ACCOUNT_USERSIG_MISMATCH_SDKAPPID(70014),

  /// éªŒè¯ UserSig æ—¶å…¬é’¥ä¸å­˜åœ¨ã€‚è¯·å…ˆç™»å½•æŽ§åˆ¶å°ä¸‹è½½ç§é’¥ï¼Œä¸‹è½½ç§é’¥çš„å…·ä½“æ–¹æ³•å¯å‚è€ƒ [ä¸‹è½½ç­¾åç”¨çš„ç§é’¥](https://cloud.tencent.com/document/product/269/32688#.E4.B8.8B.E8.BD.BD.E7.AD.BE.E5.90.8D.E7.94.A8.E7.9A.84.E7.A7.81.E9.92.A5) ã€‚
  ERR_SVR_ACCOUNT_USERSIG_PUBLICKEY_NOT_FOUND(70016),

  /// SDKAppID æœªæ‰¾åˆ°ï¼Œè¯·åœ¨äº‘é€šä¿¡ IM æŽ§åˆ¶å°ç¡®è®¤åº”ç”¨ä¿¡æ¯ã€‚
  ERR_SVR_ACCOUNT_SDKAPPID_NOT_FOUND(70020),

  /// UserSig å·²ç»å¤±æ•ˆï¼Œè¯·é‡æ–°ç”Ÿæˆï¼Œå†æ¬¡å°è¯•ã€‚
  ERR_SVR_ACCOUNT_INVALID_USERSIG(70052),

  /// è¯·æ±‚çš„ç”¨æˆ·è´¦å·ä¸å­˜åœ¨ã€‚
  ERR_SVR_ACCOUNT_NOT_FOUND(70107),

  /// å®‰å…¨åŽŸå› è¢«é™åˆ¶ã€‚
  ERR_SVR_ACCOUNT_SEC_RSTR(70114),

  /// æœåŠ¡ç«¯å†…éƒ¨è¶…æ—¶ï¼Œè¯·é‡è¯•ã€‚
  ERR_SVR_ACCOUNT_INTERNAL_TIMEOUT(70169),

  /// è¯·æ±‚ä¸­æ‰¹é‡æ•°é‡ä¸åˆæ³•ã€‚
  ERR_SVR_ACCOUNT_INVALID_COUNT(70206),

  /// å‚æ•°éžæ³•ï¼Œè¯·æ£€æŸ¥å¿…å¡«å­—æ®µæ˜¯å¦å¡«å……ï¼Œæˆ–è€…å­—æ®µçš„å¡«å……æ˜¯å¦æ»¡è¶³åè®®è¦æ±‚ã€‚
  ERR_SVR_ACCOUNT_INVALID_PARAMETERS(70402),

  /// è¯·æ±‚éœ€è¦ App ç®¡ç†å‘˜æƒé™ã€‚
  ERR_SVR_ACCOUNT_ADMIN_REQUIRED(70403),

  /// å› å¤±è´¥ä¸”é‡è¯•æ¬¡æ•°è¿‡å¤šå¯¼è‡´è¢«é™åˆ¶ï¼Œè¯·æ£€æŸ¥ UserSig æ˜¯å¦æ­£ç¡®ï¼Œä¸€åˆ†é’Ÿä¹‹åŽå†è¯•ã€‚
  ERR_SVR_ACCOUNT_FREQ_LIMIT(70050),

  /// è´¦å·è¢«æ‹‰å…¥é»‘åå•ã€‚
  ERR_SVR_ACCOUNT_BLACKLIST(70051),

  /// åˆ›å»ºè´¦å·æ•°é‡è¶…è¿‡å…è´¹ä½“éªŒç‰ˆæ•°é‡é™åˆ¶ï¼Œè¯·å‡çº§ä¸ºä¸“ä¸šç‰ˆã€‚
  ERR_SVR_ACCOUNT_COUNT_LIMIT(70398),

  /// æœåŠ¡ç«¯å†…éƒ¨é”™è¯¯ï¼Œè¯·é‡è¯•ã€‚
  ERR_SVR_ACCOUNT_INTERNAL_ERROR(70500),

  /// ç”¨æˆ·çŠ¶æ€èƒ½åŠ›éœ€è¦ç™»å½• IM æŽ§åˆ¶å°å¼€å¯
  ERR_SVR_ACCOUNT_USER_STATUS_DISABLED(72001),

  /// è¯·æ±‚å‚æ•°é”™è¯¯ï¼Œè¯·æ ¹æ®é”™è¯¯æè¿°æ£€æŸ¥è¯·æ±‚æ˜¯å¦æ­£ç¡®ã€‚
  ERR_SVR_PROFILE_INVALID_PARAMETERS(40001),

  /// è¯·æ±‚å‚æ•°é”™è¯¯ï¼Œæ²¡æœ‰æŒ‡å®šéœ€è¦æ‹‰å–èµ„æ–™çš„ç”¨æˆ·è´¦å·ã€‚
  ERR_SVR_PROFILE_ACCOUNT_MISS(40002),

  /// è¯·æ±‚çš„ç”¨æˆ·è´¦å·ä¸å­˜åœ¨ã€‚
  ERR_SVR_PROFILE_ACCOUNT_NOT_FOUND(40003),

  /// è¯·æ±‚éœ€è¦ App ç®¡ç†å‘˜æƒé™ã€‚
  ERR_SVR_PROFILE_ADMIN_REQUIRED(40004),

  /// èµ„æ–™å­—æ®µä¸­åŒ…å«æ•æ„Ÿè¯ã€‚
  ERR_SVR_PROFILE_SENSITIVE_TEXT(40005),

  /// æœåŠ¡ç«¯å†…éƒ¨é”™è¯¯ï¼Œè¯·ç¨åŽé‡è¯•ã€‚
  ERR_SVR_PROFILE_INTERNAL_ERROR(40006),

  /// æ²¡æœ‰èµ„æ–™å­—æ®µçš„è¯»æƒé™ï¼Œè¯¦æƒ…å¯å‚è§ [èµ„æ–™å­—æ®µ](https://cloud.tencent.com/document/product/269/1500#.E8.B5.84.E6.96.99.E5.AD.97.E6.AE.B5) ã€‚
  ERR_SVR_PROFILE_READ_PERMISSION_REQUIRED(40007),

  /// æ²¡æœ‰èµ„æ–™å­—æ®µçš„å†™æƒé™ï¼Œè¯¦æƒ…å¯å‚è§ [èµ„æ–™å­—æ®µ](https://cloud.tencent.com/document/product/269/1500#.E8.B5.84.E6.96.99.E5.AD.97.E6.AE.B5) ã€‚
  ERR_SVR_PROFILE_WRITE_PERMISSION_REQUIRED(40008),

  /// èµ„æ–™å­—æ®µçš„ Tag ä¸å­˜åœ¨ã€‚
  ERR_SVR_PROFILE_TAG_NOT_FOUND(40009),

  /// èµ„æ–™å­—æ®µçš„ Value é•¿åº¦è¶…è¿‡500å­—èŠ‚ã€‚
  ERR_SVR_PROFILE_SIZE_LIMIT(40601),

  /// æ ‡é…èµ„æ–™å­—æ®µçš„ Value é”™è¯¯ï¼Œè¯¦æƒ…å¯å‚è§ [æ ‡é…èµ„æ–™å­—æ®µ](https://cloud.tencent.com/doc/product/269/1500#.E6.A0.87.E9.85.8D.E8.B5.84.E6.96.99.E5.AD.97.E6.AE.B5) ã€‚
  ERR_SVR_PROFILE_VALUE_ERROR(40605),

  /// èµ„æ–™å­—æ®µçš„ Value ç±»åž‹ä¸åŒ¹é…ï¼Œè¯¦æƒ…å¯å‚è§ [æ ‡é…èµ„æ–™å­—æ®µ](https://cloud.tencent.com/doc/product/269/1500#.E6.A0.87.E9.85.8D.E8.B5.84.E6.96.99.E5.AD.97.E6.AE.B5) ã€‚
  ERR_SVR_PROFILE_INVALID_VALUE_FORMAT(40610),

  /// ç”¨æˆ·èµ„æ–™å˜æ›´è®¢é˜…èƒ½åŠ›æœªå¼€å¯ï¼Œè¯·å‚è§ [è®¢é˜…éžå¥½å‹ç”¨æˆ·èµ„æ–™](https://cloud.tencent.com/document/product/269/75416#53edea52-35ef-4d82-aae9-941ba690f051)ï¼Œç™»å½• [IM æŽ§åˆ¶å°](https://console.tencentcloud.com/im) å¼€å¯è¯¥åŠŸèƒ½ã€‚
  ERR_SVR_PROFILE_SUBSCRIPTION_DISABLED(72012),

  /// è¯·æ±‚å‚æ•°é”™è¯¯ï¼Œè¯·æ ¹æ®é”™è¯¯æè¿°æ£€æŸ¥è¯·æ±‚æ˜¯å¦æ­£ç¡®ã€‚
  ERR_SVR_FRIENDSHIP_INVALID_PARAMETERS(30001),

  /// SDKAppID ä¸åŒ¹é…ã€‚
  ERR_SVR_FRIENDSHIP_INVALID_SDKAPPID(30002),

  /// è¯·æ±‚çš„ç”¨æˆ·è´¦å·ä¸å­˜åœ¨ã€‚
  ERR_SVR_FRIENDSHIP_ACCOUNT_NOT_FOUND(30003),

  /// è¯·æ±‚éœ€è¦ App ç®¡ç†å‘˜æƒé™ã€‚
  ERR_SVR_FRIENDSHIP_ADMIN_REQUIRED(30004),

  /// å…³ç³»é“¾å­—æ®µä¸­åŒ…å«æ•æ„Ÿè¯ã€‚
  ERR_SVR_FRIENDSHIP_SENSITIVE_TEXT(30005),

  /// æœåŠ¡ç«¯å†…éƒ¨é”™è¯¯ï¼Œè¯·é‡è¯•ã€‚
  ERR_SVR_FRIENDSHIP_INTERNAL_ERROR(30006),

  /// ç½‘ç»œè¶…æ—¶ï¼Œè¯·ç¨åŽé‡è¯•ã€‚
  ERR_SVR_FRIENDSHIP_NET_TIMEOUT(30007),

  /// å¹¶å‘å†™å¯¼è‡´å†™å†²çªï¼Œå»ºè®®ä½¿ç”¨æ‰¹é‡æ–¹å¼ã€‚
  ERR_SVR_FRIENDSHIP_WRITE_CONFLICT(30008),

  /// åŽå°ç¦æ­¢è¯¥ç”¨æˆ·å‘èµ·åŠ å¥½å‹è¯·æ±‚ã€‚
  ERR_SVR_FRIENDSHIP_ADD_FRIEND_DENY(30009),

  /// è‡ªå·±çš„å¥½å‹æ•°å·²è¾¾ç³»ç»Ÿä¸Šé™ã€‚
  ERR_SVR_FRIENDSHIP_COUNT_LIMIT(30010),

  /// åˆ†ç»„å·²è¾¾ç³»ç»Ÿä¸Šé™ã€‚
  ERR_SVR_FRIENDSHIP_GROUP_COUNT_LIMIT(30011),

  /// æœªå†³æ•°å·²è¾¾ç³»ç»Ÿä¸Šé™ã€‚
  ERR_SVR_FRIENDSHIP_PENDENCY_LIMIT(30012),

  /// é»‘åå•æ•°å·²è¾¾ç³»ç»Ÿä¸Šé™ã€‚
  ERR_SVR_FRIENDSHIP_BLACKLIST_LIMIT(30013),

  /// å¯¹æ–¹çš„å¥½å‹æ•°å·²è¾¾ç³»ç»Ÿä¸Šé™ã€‚
  ERR_SVR_FRIENDSHIP_PEER_FRIEND_LIMIT(30014),

  /// å·²ç»å­˜åœ¨å¥½å‹å…³ç³»ã€‚
  ERR_SVR_FRIENDSHIP_ALREADY_FRIENDS(30015),

  /// è¯·æ±‚æ·»åŠ å¥½å‹æ—¶ï¼Œå¯¹æ–¹åœ¨è‡ªå·±çš„é»‘åå•ä¸­ï¼Œä¸å…è®¸åŠ å¥½å‹ã€‚
  ERR_SVR_FRIENDSHIP_IN_SELF_BLACKLIST(30515),

  /// è¯·æ±‚æ·»åŠ å¥½å‹æ—¶ï¼Œå¯¹æ–¹çš„åŠ å¥½å‹éªŒè¯æ–¹å¼æ˜¯ä¸å…è®¸ä»»ä½•äººæ·»åŠ è‡ªå·±ä¸ºå¥½å‹ã€‚
  ERR_SVR_FRIENDSHIP_ALLOW_TYPE_DENY_ANY(30516),

  /// è¯·æ±‚æ·»åŠ å¥½å‹æ—¶ï¼Œè‡ªå·±åœ¨å¯¹æ–¹çš„é»‘åå•ä¸­ï¼Œä¸å…è®¸åŠ å¥½å‹ã€‚
  ERR_SVR_FRIENDSHIP_IN_PEER_BLACKLIST(30525),

  /// A è¯·æ±‚åŠ  B ä¸ºå¥½å‹ï¼ŒB çš„åŠ å¥½å‹éªŒè¯æ–¹å¼è¢«è®¾ç½®ä¸ºâ€œAllowType_Type_NeedConfirmâ€ï¼Œè¿™æ—¶ A ä¸Ž B ä¹‹é—´åªèƒ½å½¢æˆæœªå†³å…³ç³»ï¼Œè¯¥è¿”å›žç ç”¨äºŽæ ‡è¯†åŠ æœªå†³æˆåŠŸï¼Œä»¥ä¾¿ä¸ŽåŠ å¥½å‹æˆåŠŸçš„è¿”å›žç åŒºåˆ†å¼€ï¼Œè°ƒç”¨æ–¹å¯ä»¥æ•æ‰è¯¥é”™è¯¯ç»™ç”¨æˆ·ä¸€ä¸ªåˆç†çš„æç¤ºã€‚
  ERR_SVR_FRIENDSHIP_ALLOW_TYPE_NEED_CONFIRM(30539),

  /// æ·»åŠ å¥½å‹è¯·æ±‚è¢«å®‰å…¨ç­–ç•¥æ‰“å‡»ï¼Œè¯·å‹¿é¢‘ç¹å‘èµ·æ·»åŠ å¥½å‹è¯·æ±‚ã€‚
  ERR_SVR_FRIENDSHIP_ADD_FRIEND_SEC_RSTR(30540),

  /// è¯·æ±‚çš„æœªå†³ä¸å­˜åœ¨ã€‚
  ERR_SVR_FRIENDSHIP_PENDENCY_NOT_FOUND(30614),

  /// ä¸Žè¯·æ±‚åˆ é™¤çš„è´¦å·ä¹‹é—´ä¸å­˜åœ¨å¥½å‹å…³ç³»ã€‚
  ERR_SVR_FRIENDSHIP_DEL_NONFRIEND(31704),

  /// åˆ é™¤å¥½å‹è¯·æ±‚è¢«å®‰å…¨ç­–ç•¥æ‰“å‡»ï¼Œè¯·å‹¿é¢‘ç¹å‘èµ·åˆ é™¤å¥½å‹è¯·æ±‚ã€‚
  ERR_SVR_FRIENDSHIP_DEL_FRIEND_SEC_RSTR(31707),

  /// è¯·æ±‚çš„ç”¨æˆ·è´¦å·ä¸å­˜åœ¨ã€‚
  ERR_SVR_FRIENDSHIP_ACCOUNT_NOT_FOUND_EX(31804),

  /// è‡ªå·±çš„å…³æ³¨æ•°é‡åˆ°è¾¾ä¸Šé™ã€‚
  ERR_SVR_FRIENDSHIP_SELF_FOLLOWING_COUNT_EXCEEDS_LIMIT(32100),

  /// å¯¹æ–¹çš„ç²‰ä¸æ•°é‡åˆ°è¾¾ä¸Šé™ã€‚
  ERR_SVR_FRIENDSHIP_PEER_FOLLOWERS_COUNT_EXCEEDS_LIMIT(32101),

  /// è‡ªå·±çš„äº’å…³æ•°é‡åˆ°è¾¾ä¸Šé™ã€‚
  ERR_SVR_FRIENDSHIP_SELF_MUTUAL_FOLLOWERS_COUNT_EXCEEDS_LIMIT(32102),

  /// å¯¹æ–¹çš„äº’å…³æ•°é‡åˆ°è¾¾ä¸Šé™ã€‚
  ERR_SVR_FRIENDSHIP_PEER_MUTUAL_FOLLOWERS_COUNT_EXCEEDS_LIMIT(32103),

  /// è¯·æ±‚çš„ç”¨æˆ·è´¦å·ä¸å­˜åœ¨ã€‚
  ERR_SVR_CONV_ACCOUNT_NOT_FOUND(50001),

  /// è¯·æ±‚å‚æ•°é”™è¯¯ï¼Œè¯·æ ¹æ®é”™è¯¯æè¿°æ£€æŸ¥è¯·æ±‚æ˜¯å¦æ­£ç¡®ã€‚
  ERR_SVR_CONV_INVALID_PARAMETERS(50002),

  /// è¯·æ±‚éœ€è¦ App ç®¡ç†å‘˜æƒé™ã€‚
  ERR_SVR_CONV_ADMIN_REQUIRED(50003),

  /// æœåŠ¡ç«¯å†…éƒ¨é”™è¯¯ï¼Œè¯·é‡è¯•ã€‚
  ERR_SVR_CONV_INTERNAL_ERROR(50004),

  /// ç½‘ç»œè¶…æ—¶ï¼Œè¯·ç¨åŽé‡è¯•ã€‚
  ERR_SVR_CONV_NET_TIMEOUT(50005),

  /// ä¸€æ¬¡æ ‡è®°ã€åˆ†ç»„ã€è®¾ç½®è‡ªå®šä¹‰æ•°æ®çš„ä¼šè¯æ•°è¶…è¿‡äº†ä¸Šé™ï¼ˆæœ€å¤§æ”¯æŒ 100 ä¸ªï¼‰
  ERR_SVR_CONV_CONV_MARK_REQ_COUNT_EXCEED_LIMIT(51006),

  /// Group ä¼šè¯æ“ä½œå¼‚å¸¸ï¼ŒServer å†…éƒ¨é”™è¯¯æˆ– Group å·²ç»è§£æ•£
  ERR_SVR_CONV_CONV_MARK_OPERATE_FAILED(51007),

  /// æ ‡è®°ã€åˆ†ç»„ã€è®¾ç½®è‡ªå®šä¹‰æ•°æ®çš„æ€»ä¼šè¯æ•°è¶…è¿‡äº†ä¸Šé™ï¼ˆæœ€å¤§æ”¯æŒ 1000 ä¸ªï¼‰
  ERR_SVR_CONV_CONV_MARK_TOTAL_COUNT_EXCEED_LIMIT(51008),

  /// ä¼šè¯åˆ†ç»„ä¸å­˜åœ¨
  ERR_SVR_CONV_CONV_GROUP_NOT_EXIST(51009),

  /// ä¼šè¯åˆ†ç»„æ•°è¶…è¿‡äº†ä¸Šé™ï¼ˆæœ€å¤§æ”¯æŒ 20 ä¸ªï¼‰
  ERR_SVR_CONV_CONV_GROUP_TOTAL_COUNT_EXCEED_LIMIT(51010),

  /// ä¼šè¯åˆ†ç»„åå­—èŠ‚æ•°è¶…è¿‡äº†ä¸Šé™ï¼ˆæœ€å¤§æ”¯æŒ 32 å­—èŠ‚ï¼‰
  ERR_SVR_CONV_CONV_GROUP_NAME_EXCEED_LENGTH(51011),

  /// è¯·æ±‚åŒ…éžæ³•ï¼Œè¯·æ£€æŸ¥å‘é€æ–¹å’ŒæŽ¥æ”¶æ–¹è´¦å·æ˜¯å¦å­˜åœ¨ã€‚
  ERR_SVR_MSG_PKG_PARSE_FAILED(20001),

  /// å†…éƒ¨é‰´æƒå¤±è´¥ã€‚
  ERR_SVR_MSG_INTERNAL_AUTH_FAILED(20002),

  /// Identifier æ— æ•ˆæˆ–è€… Identifier æœªå¯¼å…¥äº‘é€šä¿¡ IMã€‚
  ERR_SVR_MSG_INVALID_ID(20003),

  /// ç½‘ç»œå¼‚å¸¸ï¼Œè¯·é‡è¯•ã€‚
  ERR_SVR_MSG_NET_ERROR(20004),

  /// æœåŠ¡ç«¯å†…éƒ¨é”™è¯¯ï¼Œè¯·é‡è¯•ã€‚
  ERR_SVR_MSG_INTERNAL_ERROR1(20005),

  /// è§¦å‘å‘é€å•èŠæ¶ˆæ¯ä¹‹å‰å›žè°ƒï¼ŒApp åŽå°è¿”å›žç¦æ­¢ä¸‹å‘è¯¥æ¶ˆæ¯ã€‚
  ERR_SVR_MSG_PUSH_DENY(20006),

  /// å‘é€å•èŠæ¶ˆæ¯ï¼Œè¢«å¯¹æ–¹æ‹‰é»‘ï¼Œç¦æ­¢å‘é€ã€‚
  ERR_SVR_MSG_IN_PEER_BLACKLIST(20007),

  /// æ¶ˆæ¯å‘é€åŒæ–¹äº’ç›¸ä¸æ˜¯å¥½å‹ï¼Œç¦æ­¢å‘é€ï¼ˆé…ç½®å•èŠæ¶ˆæ¯æ ¡éªŒå¥½å‹å…³ç³»æ‰ä¼šå‡ºçŽ°ï¼‰ã€‚
  ERR_SVR_MSG_BOTH_NOT_FRIEND(20009),

  /// å‘é€å•èŠæ¶ˆæ¯ï¼Œè‡ªå·±ä¸æ˜¯å¯¹æ–¹çš„å¥½å‹ï¼ˆå•å‘å…³ç³»ï¼‰ï¼Œç¦æ­¢å‘é€ã€‚
  ERR_SVR_MSG_NOT_PEER_FRIEND(20010),

  /// å‘é€å•èŠæ¶ˆæ¯ï¼Œå¯¹æ–¹ä¸æ˜¯è‡ªå·±çš„å¥½å‹ï¼ˆå•å‘å…³ç³»ï¼‰ï¼Œç¦æ­¢å‘é€ã€‚
  ERR_SVR_MSG_NOT_SELF_FRIEND(20011),

  /// å› ç¦è¨€ï¼Œç¦æ­¢å‘é€æ¶ˆæ¯ã€‚
  ERR_SVR_MSG_SHUTUP_DENY(20012),

  /// æ¶ˆæ¯æ’¤å›žè¶…è¿‡äº†æ—¶é—´é™åˆ¶ï¼ˆé»˜è®¤2åˆ†é’Ÿï¼‰ã€‚
  ERR_SVR_MSG_REVOKE_TIME_LIMIT(20016),

  /// åˆ é™¤æ¼«æ¸¸å†…éƒ¨é”™è¯¯ã€‚
  ERR_SVR_MSG_DEL_RAMBLE_INTERNAL_ERROR(20018),

  /// æ¶ˆæ¯æ‰©å±•æ“ä½œå†²çªã€‚
  ERR_SVR_MSG_EXTENSION_CONFLICT(23001),

  /// åˆ é™¤çš„æ¶ˆæ¯æ‰©å±•ä¸å­˜åœ¨ã€‚
  ERR_SVR_MSG_EXTENSION_NOT_EXIST(23004),

  /// å•æ¡æ¶ˆæ¯ Reaction æ•°é‡è¶…è¿‡æœ€å¤§é™åˆ¶ã€‚
  ERR_SVR_MSG_REACTION_COUNT_LIMIT(23005),

  /// å•ä¸ª Reaction ç”¨æˆ·æ•°é‡è¶…è¿‡æœ€å¤§é™åˆ¶ã€‚
  ERR_SVR_MSG_REACTION_USER_COUNT_LIMIT(23006),

  /// Reaction å·²ç»åŒ…å«å½“å‰æ“ä½œç”¨æˆ·ã€‚
  ERR_SVR_MSG_REACTION_ALREADY_CONTAIN_USER(23007),

  /// Reaction ä¸å­˜åœ¨ã€‚
  ERR_SVR_MSG_REACTION_NOT_EXISTS(23008),

  /// Reaction ä¸åŒ…å«å½“å‰æ“ä½œç”¨æˆ·ã€‚
  ERR_SVR_MSG_REACTION_NOT_CONTAIN_USER(23009),

  /// JSON æ ¼å¼è§£æžå¤±è´¥ï¼Œè¯·æ£€æŸ¥è¯·æ±‚åŒ…æ˜¯å¦ç¬¦åˆ JSON è§„èŒƒã€‚
  ERR_SVR_MSG_JSON_PARSE_FAILED(90001),

  /// JSON æ ¼å¼è¯·æ±‚åŒ…ä¸­ MsgBody ä¸ç¬¦åˆæ¶ˆæ¯æ ¼å¼æè¿°ï¼Œæˆ–è€… MsgBody ä¸æ˜¯ Array ç±»åž‹ï¼Œè¯·å‚è€ƒ [TIMMsgElement å¯¹è±¡](https://cloud.tencent.com/document/product/269/2720#.E6.B6.88.E6.81.AF.E5.85.83.E7.B4.A0timmsgelement) çš„å®šä¹‰ã€‚
  ERR_SVR_MSG_INVALID_JSON_BODY_FORMAT(90002),

  /// JSON æ ¼å¼è¯·æ±‚åŒ…ä½“ä¸­ç¼ºå°‘ To_Account å­—æ®µæˆ–è€… To_Account å­—æ®µä¸æ˜¯ Integer ç±»åž‹
  ERR_SVR_MSG_INVALID_TO_ACCOUNT(90003),

  /// JSON æ ¼å¼è¯·æ±‚åŒ…ä½“ä¸­ç¼ºå°‘ MsgRandom å­—æ®µæˆ–è€… MsgRandom å­—æ®µä¸æ˜¯ Integer ç±»åž‹
  ERR_SVR_MSG_INVALID_RAND(90005),

  /// JSON æ ¼å¼è¯·æ±‚åŒ…ä½“ä¸­ç¼ºå°‘ MsgTimeStamp å­—æ®µæˆ–è€… MsgTimeStamp å­—æ®µä¸æ˜¯ Integer ç±»åž‹
  ERR_SVR_MSG_INVALID_TIMESTAMP(90006),

  /// JSON æ ¼å¼è¯·æ±‚åŒ…ä½“ä¸­ MsgBody ç±»åž‹ä¸æ˜¯ Array ç±»åž‹ï¼Œè¯·å°†å…¶ä¿®æ”¹ä¸º Array ç±»åž‹
  ERR_SVR_MSG_BODY_NOT_ARRAY(90007),

  /// è¯·æ±‚éœ€è¦ App ç®¡ç†å‘˜æƒé™ã€‚
  ERR_SVR_MSG_ADMIN_REQUIRED(90009),

  /// JSON æ ¼å¼è¯·æ±‚åŒ…ä¸ç¬¦åˆæ¶ˆæ¯æ ¼å¼æè¿°ï¼Œè¯·å‚è€ƒ [TIMMsgElement å¯¹è±¡](https://cloud.tencent.com/document/product/269/2720#.E6.B6.88.E6.81.AF.E5.85.83.E7.B4.A0timmsgelement) çš„å®šä¹‰ã€‚
  ERR_SVR_MSG_INVALID_JSON_FORMAT(90010),

  /// æ‰¹é‡å‘æ¶ˆæ¯ç›®æ ‡è´¦å·è¶…è¿‡500ï¼Œè¯·å‡å°‘ To_Account ä¸­ç›®æ ‡è´¦å·æ•°é‡ã€‚
  ERR_SVR_MSG_TO_ACCOUNT_COUNT_LIMIT(90011),

  /// To_Account æ²¡æœ‰æ³¨å†Œæˆ–ä¸å­˜åœ¨ï¼Œè¯·ç¡®è®¤ To_Account æ˜¯å¦å¯¼å…¥äº‘é€šä¿¡ IM æˆ–è€…æ˜¯å¦æ‹¼å†™é”™è¯¯ã€‚
  ERR_SVR_MSG_TO_ACCOUNT_NOT_FOUND(90012),

  /// æ¶ˆæ¯ç¦»çº¿å­˜å‚¨æ—¶é—´é”™è¯¯ï¼ˆæœ€å¤šä¸èƒ½è¶…è¿‡7å¤©ï¼‰ã€‚
  ERR_SVR_MSG_TIME_LIMIT(90026),

  /// JSON æ ¼å¼è¯·æ±‚åŒ…ä½“ä¸­ SyncOtherMachine å­—æ®µä¸æ˜¯ Integer ç±»åž‹
  ERR_SVR_MSG_INVALID_SYNCOTHERMACHINE(90031),

  /// JSON æ ¼å¼è¯·æ±‚åŒ…ä½“ä¸­ MsgLifeTime å­—æ®µä¸æ˜¯ Integer ç±»åž‹
  ERR_SVR_MSG_INVALID_MSGLIFETIME(90044),

  /// è¯·æ±‚çš„ç”¨æˆ·è´¦å·ä¸å­˜åœ¨ã€‚
  ERR_SVR_MSG_ACCOUNT_NOT_FOUND(90048),

  /// æœåŠ¡å†…éƒ¨é”™è¯¯ï¼Œè¯·é‡è¯•ã€‚
  ERR_SVR_MSG_INTERNAL_ERROR2(90994),

  /// æœåŠ¡å†…éƒ¨é”™è¯¯ï¼Œè¯·é‡è¯•ã€‚
  ERR_SVR_MSG_INTERNAL_ERROR3(90995),

  /// æœåŠ¡å†…éƒ¨é”™è¯¯ï¼Œè¯·é‡è¯•ã€‚
  ERR_SVR_MSG_INTERNAL_ERROR4(91000),

  /// æœåŠ¡å†…éƒ¨é”™è¯¯ï¼Œè¯·é‡è¯•ï¼›å¦‚æžœæ‰€æœ‰è¯·æ±‚éƒ½è¿”å›žè¯¥é”™è¯¯ç ï¼Œä¸” App é…ç½®äº†ç¬¬ä¸‰æ–¹å›žè°ƒï¼Œè¯·æ£€æŸ¥ App æœåŠ¡ç«¯æ˜¯å¦æ­£å¸¸å‘äº‘é€šä¿¡ IM åŽå°æœåŠ¡ç«¯è¿”å›žå›žè°ƒç»“æžœã€‚
  ERR_SVR_MSG_INTERNAL_ERROR5(90992),

  /// JSON æ•°æ®åŒ…è¶…é•¿ï¼Œæ¶ˆæ¯åŒ…ä½“è¯·ä¸è¦è¶…è¿‡12kã€‚
  ERR_SVR_MSG_BODY_SIZE_LIMIT(93000),

  /// Web ç«¯é•¿è½®è¯¢è¢«è¸¢ï¼ˆWeb ç«¯åŒæ—¶åœ¨çº¿å®žä¾‹ä¸ªæ•°è¶…å‡ºé™åˆ¶ï¼‰ã€‚
  ERR_SVR_MSG_LONGPOLLING_COUNT_LIMIT(91101),

  /// æœåŠ¡ç«¯å†…éƒ¨é”™è¯¯ï¼Œè¯·é‡è¯•ã€‚
  ERR_SVR_GROUP_INTERNAL_ERROR(10002),

  /// è¯·æ±‚ä¸­çš„æŽ¥å£åç§°é”™è¯¯ï¼Œè¯·æ ¸å¯¹æŽ¥å£åç§°å¹¶é‡è¯•ã€‚
  ERR_SVR_GROUP_API_NAME_ERROR(10003),

  /// å‚æ•°éžæ³•ï¼Œè¯·æ ¹æ®é”™è¯¯æè¿°æ£€æŸ¥è¯·æ±‚æ˜¯å¦æ­£ç¡®ã€‚
  ERR_SVR_GROUP_INVALID_PARAMETERS(10004),

  /// è¯·æ±‚åŒ…ä½“ä¸­æºå¸¦çš„è´¦å·æ•°é‡è¿‡å¤šã€‚
  ERR_SVR_GROUP_ACOUNT_COUNT_LIMIT(10005),

  /// æ“ä½œé¢‘çŽ‡é™åˆ¶ï¼Œè¯·å°è¯•é™ä½Žè°ƒç”¨çš„é¢‘çŽ‡ã€‚
  ERR_SVR_GROUP_FREQ_LIMIT(10006),

  /// æ“ä½œæƒé™ä¸è¶³ï¼Œæ¯”å¦‚ Public ç¾¤ç»„ä¸­æ™®é€šæˆå‘˜å°è¯•æ‰§è¡Œè¸¢äººæ“ä½œï¼Œä½†åªæœ‰ App ç®¡ç†å‘˜æ‰æœ‰æƒé™ã€‚
  ERR_SVR_GROUP_PERMISSION_DENY(10007),

  /// è¯·æ±‚éžæ³•ï¼Œå¯èƒ½æ˜¯è¯·æ±‚ä¸­æºå¸¦çš„ç­¾åä¿¡æ¯éªŒè¯ä¸æ­£ç¡®ï¼Œè¯·å†æ¬¡å°è¯•æˆ– [æäº¤å·¥å•](https://console.cloud.tencent.com/workorder/category?level1_id=29&level2_id=40&source=0&data_title=%E4%BA%91%E9%80%9A%E4%BF%A1%20%20IM&step=1) è”ç³»æŠ€æœ¯å®¢æœã€‚
  ERR_SVR_GROUP_INVALID_REQ(10008),

  /// è¯¥ç¾¤ä¸å…è®¸ç¾¤ä¸»ä¸»åŠ¨é€€å‡ºã€‚
  ERR_SVR_GROUP_SUPER_NOT_ALLOW_QUIT(10009),

  /// ç¾¤ç»„ä¸å­˜åœ¨ï¼Œæˆ–è€…æ›¾ç»å­˜åœ¨è¿‡ï¼Œä½†æ˜¯ç›®å‰å·²ç»è¢«è§£æ•£ã€‚
  ERR_SVR_GROUP_NOT_FOUND(10010),

  /// è§£æž JSON åŒ…ä½“å¤±è´¥ï¼Œè¯·æ£€æŸ¥åŒ…ä½“çš„æ ¼å¼æ˜¯å¦ç¬¦åˆ JSON æ ¼å¼ã€‚
  ERR_SVR_GROUP_JSON_PARSE_FAILED(10011),

  /// å‘èµ·æ“ä½œçš„ Identifier éžæ³•ï¼Œè¯·æ£€æŸ¥å‘èµ·æ“ä½œçš„ç”¨æˆ· Identifier æ˜¯å¦å¡«å†™æ­£ç¡®ã€‚
  ERR_SVR_GROUP_INVALID_ID(10012),

  /// è¢«é‚€è¯·åŠ å…¥çš„ç”¨æˆ·å·²ç»æ˜¯ç¾¤æˆå‘˜ã€‚
  ERR_SVR_GROUP_ALLREADY_MEMBER(10013),

  /// ç¾¤å·²æ»¡å‘˜ï¼Œæ— æ³•å°†è¯·æ±‚ä¸­çš„ç”¨æˆ·åŠ å…¥ç¾¤ç»„ï¼Œå¦‚æžœæ˜¯æ‰¹é‡åŠ äººï¼Œå¯ä»¥å°è¯•å‡å°‘åŠ å…¥ç”¨æˆ·çš„æ•°é‡ã€‚
  ERR_SVR_GROUP_FULL_MEMBER_COUNT(10014),

  /// ç¾¤ç»„ ID éžæ³•ï¼Œè¯·æ£€æŸ¥ç¾¤ç»„ ID æ˜¯å¦å¡«å†™æ­£ç¡®ã€‚
  ERR_SVR_GROUP_INVALID_GROUPID(10015),

  /// App åŽå°é€šè¿‡ç¬¬ä¸‰æ–¹å›žè°ƒæ‹’ç»æœ¬æ¬¡æ“ä½œã€‚
  ERR_SVR_GROUP_REJECT_FROM_THIRDPARTY(10016),

  /// å› è¢«ç¦è¨€è€Œä¸èƒ½å‘é€æ¶ˆæ¯ï¼Œè¯·æ£€æŸ¥å‘é€è€…æ˜¯å¦è¢«è®¾ç½®ç¦è¨€ã€‚
  ERR_SVR_GROUP_SHUTUP_DENY(10017),

  /// åº”ç­”åŒ…é•¿åº¦è¶…è¿‡æœ€å¤§åŒ…é•¿ï¼ˆ1MBï¼‰ï¼Œè¯·æ±‚çš„å†…å®¹è¿‡å¤šï¼Œè¯·å°è¯•å‡å°‘å•æ¬¡è¯·æ±‚çš„æ•°æ®é‡ã€‚
  ERR_SVR_GROUP_RSP_SIZE_LIMIT(10018),

  /// è¯·æ±‚çš„ç”¨æˆ·è´¦å·ä¸å­˜åœ¨ã€‚
  ERR_SVR_GROUP_ACCOUNT_NOT_FOUND(10019),

  /// ç¾¤ç»„ ID å·²è¢«ä½¿ç”¨ï¼Œè¯·é€‰æ‹©å…¶ä»–çš„ç¾¤ç»„ IDã€‚
  ERR_SVR_GROUP_GROUPID_IN_USED(10021),

  /// å‘æ¶ˆæ¯çš„é¢‘çŽ‡è¶…é™ï¼Œè¯·å»¶é•¿ä¸¤æ¬¡å‘æ¶ˆæ¯æ—¶é—´çš„é—´éš”ã€‚
  ERR_SVR_GROUP_SEND_MSG_FREQ_LIMIT(10023),

  /// æ­¤é‚€è¯·æˆ–è€…ç”³è¯·è¯·æ±‚å·²ç»è¢«å¤„ç†ã€‚
  ERR_SVR_GROUP_REQ_ALLREADY_BEEN_PROCESSED(10024),

  /// ç¾¤ç»„ ID å·²è¢«ä½¿ç”¨ï¼Œå¹¶ä¸”æ“ä½œè€…ä¸ºç¾¤ä¸»ï¼Œå¯ä»¥ç›´æŽ¥ä½¿ç”¨ã€‚
  ERR_SVR_GROUP_GROUPID_IN_USED_FOR_SUPER(10025),

  /// è¯¥ SDKAppID è¯·æ±‚çš„å‘½ä»¤å­—å·²è¢«ç¦ç”¨ï¼Œè¯· [æäº¤å·¥å•](https://console.cloud.tencent.com/workorder/category?level1_id=29&level2_id=40&source=0&data_title=%E4%BA%91%E9%80%9A%E4%BF%A1%20%20IM&step=1) è”ç³»å®¢æœã€‚
  ERR_SVR_GROUP_SDKAPPID_DENY(10026),

  /// è¯·æ±‚æ’¤å›žçš„æ¶ˆæ¯ä¸å­˜åœ¨ã€‚
  ERR_SVR_GROUP_REVOKE_MSG_NOT_FOUND(10030),

  /// æ¶ˆæ¯æ’¤å›žè¶…è¿‡äº†æ—¶é—´é™åˆ¶ï¼ˆé»˜è®¤2åˆ†é’Ÿï¼‰ã€‚
  ERR_SVR_GROUP_REVOKE_MSG_TIME_LIMIT(10031),

  /// è¯·æ±‚æ’¤å›žçš„æ¶ˆæ¯ä¸æ”¯æŒæ’¤å›žæ“ä½œã€‚
  ERR_SVR_GROUP_REVOKE_MSG_DENY(10032),

  /// ç¾¤ç»„ç±»åž‹ä¸æ”¯æŒæ¶ˆæ¯æ’¤å›žæ“ä½œã€‚
  ERR_SVR_GROUP_NOT_ALLOW_REVOKE_MSG(10033),

  /// è¯¥æ¶ˆæ¯ç±»åž‹ä¸æ”¯æŒåˆ é™¤æ“ä½œã€‚
  ERR_SVR_GROUP_REMOVE_MSG_DENY(10034),

  /// éŸ³è§†é¢‘èŠå¤©å®¤å’Œåœ¨çº¿æˆå‘˜å¹¿æ’­å¤§ç¾¤ä¸æ”¯æŒåˆ é™¤æ¶ˆæ¯ã€‚
  ERR_SVR_GROUP_NOT_ALLOW_REMOVE_MSG(10035),

  /// éŸ³è§†é¢‘èŠå¤©å®¤åˆ›å»ºæ•°é‡è¶…è¿‡äº†é™åˆ¶ï¼Œè¯·å‚è€ƒ [ä»·æ ¼è¯´æ˜Ž](https://cloud.tencent.com/document/product/269/11673) è´­ä¹°é¢„ä»˜è´¹å¥—é¤â€œIMéŸ³è§†é¢‘èŠå¤©å®¤â€ã€‚
  ERR_SVR_GROUP_AVCHATROOM_COUNT_LIMIT(10036),

  /// å•ä¸ªç”¨æˆ·å¯åˆ›å»ºå’ŒåŠ å…¥çš„ç¾¤ç»„æ•°é‡è¶…è¿‡äº†é™åˆ¶ï¼Œè¯·å‚è€ƒ [ä»·æ ¼è¯´æ˜Ž](https://cloud.tencent.com/document/product/269/11673) è´­ä¹°æˆ–å‡çº§é¢„ä»˜è´¹å¥—é¤â€œå•äººå¯åˆ›å»ºä¸ŽåŠ å…¥ç¾¤ç»„æ•°â€ã€‚
  ERR_SVR_GROUP_COUNT_LIMIT(10037),

  /// ç¾¤æˆå‘˜æ•°é‡è¶…è¿‡é™åˆ¶ï¼Œè¯·å‚è€ƒ [ä»·æ ¼è¯´æ˜Ž](https://cloud.tencent.com/document/product/269/11673) è´­ä¹°æˆ–å‡çº§é¢„ä»˜è´¹å¥—é¤â€œæ‰©å±•ç¾¤äººæ•°ä¸Šé™â€ã€‚
  ERR_SVR_GROUP_MEMBER_COUNT_LIMIT(10038),

  /// ç¾¤å±žæ€§å†™å†²çªï¼Œè¯·å…ˆæ‹‰å–æœ€æ–°çš„ç¾¤å±žæ€§åŽå†å°è¯•å†™æ“ä½œï¼ŒIMSDK  5.6 åŠå…¶ä»¥ä¸Šç‰ˆæœ¬æ”¯æŒã€‚
  ERR_SVR_GROUP_ATTRIBUTE_WRITE_CONFILCT(10056),

  /// ç½®é¡¶æ¶ˆæ¯è¶…å‡ºæ•°é‡é™åˆ¶æ—¶ã€‚
  ERR_SVR_GROUP_PINNED_MESSAGE_COUNT_LIMIT(10070),

  /// æ¶ˆæ¯å·²ç»è¢«ç½®é¡¶ã€‚
  ERR_SVR_GROUP_MESSAGE_ALREADY_PINNED(10071),

  /// æ‰¹é‡æ“ä½œæ— æˆåŠŸç»“æžœã€‚
  ERR_NO_SUCC_RESULT(6003),

  /// æ— æ•ˆæŽ¥æ”¶æ–¹ã€‚
  ERR_TO_USER_INVALID(6011),

  /// è¯·æ±‚è¶…æ—¶ã€‚
  ERR_REQUEST_TIME_OUT(6012),

  /// INIT CORE æ¨¡å—å¤±è´¥ã€‚
  ERR_INIT_CORE_FAIL(6018),

  /// SessionNode ä¸º null ã€‚
  ERR_EXPIRED_SESSION_NODE(6020),

  /// åœ¨ç™»å½•å®Œæˆå‰è¿›è¡Œäº†ç™»å‡ºï¼ˆåœ¨ç™»å½•æ—¶è¿”å›žï¼‰ã€‚
  ERR_LOGGED_OUT_BEFORE_LOGIN_FINISHED(6023),

  /// TLS SDK æœªåˆå§‹åŒ–ã€‚
  ERR_TLSSDK_NOT_INITIALIZED(6024),

  /// TLS SDK æ²¡æœ‰æ‰¾åˆ°ç›¸åº”çš„ç”¨æˆ·ä¿¡æ¯ã€‚
  ERR_TLSSDK_USER_NOT_FOUND(6025),

  /// QALSDK æœªçŸ¥åŽŸå› BINDå¤±è´¥ã€‚
  ERR_BIND_FAIL_UNKNOWN(6100),

  /// ç¼ºå°‘ SSO ç¥¨æ®ã€‚
  ERR_BIND_FAIL_NO_SSOTICKET(6101),

  /// é‡å¤ BINDã€‚
  ERR_BIND_FAIL_REPEATD_BIND(6102),

  /// TinyId ä¸ºç©ºã€‚
  ERR_BIND_FAIL_TINYID_NULL(6103),

  /// GUID ä¸ºç©ºã€‚
  ERR_BIND_FAIL_GUID_NULL(6104),

  /// è§£æ³¨å†ŒåŒ…å¤±è´¥ã€‚
  ERR_BIND_FAIL_UNPACK_REGPACK_FAILED(6105),

  /// æ³¨å†Œè¶…æ—¶ã€‚
  ERR_BIND_FAIL_REG_TIMEOUT(6106),

  /// æ­£åœ¨ BIND æ“ä½œä¸­ã€‚
  ERR_BIND_FAIL_ISBINDING(6107),

  /// å‘åŒ…æœªçŸ¥é”™è¯¯ã€‚
  ERR_PACKET_FAIL_UNKNOWN(6120),

  /// å‘é€è¯·æ±‚åŒ…æ—¶æ²¡æœ‰ç½‘ç»œã€‚
  ERR_PACKET_FAIL_REQ_NO_NET(6121),

  /// å‘é€å›žå¤åŒ…æ—¶æ²¡æœ‰ç½‘ç»œã€‚
  ERR_PACKET_FAIL_RESP_NO_NET(6122),

  /// å‘é€è¯·æ±‚åŒ…æ—¶æ²¡æœ‰æƒé™ã€‚
  ERR_PACKET_FAIL_REQ_NO_AUTH(6123),

  /// SSO é”™è¯¯ã€‚
  ERR_PACKET_FAIL_SSO_ERR(6124),

  /// è¯·æ±‚è¶…æ—¶ã€‚
  ERR_PACKET_FAIL_REQ_TIMEOUT(6125),

  /// å›žå¤è¶…æ—¶ã€‚
  ERR_PACKET_FAIL_RESP_TIMEOUT(6126),

  /// é‡å‘å¤±è´¥ã€‚
  ERR_PACKET_FAIL_REQ_ON_RESEND(6127),

  /// é‡å‘æ—¶æ²¡æœ‰çœŸæ­£å‘é€ã€‚
  ERR_PACKET_FAIL_RESP_NO_RESEND(6128),

  /// ä¿å­˜è¢«è¿‡æ»¤ã€‚
  ERR_PACKET_FAIL_FLOW_SAVE_FILTERED(6129),

  /// å‘é€è¿‡è½½ã€‚
  ERR_PACKET_FAIL_REQ_OVER_LOAD(6130),

  /// æ•°æ®é€»è¾‘é”™è¯¯ã€‚
  ERR_PACKET_FAIL_LOGIC_ERR(6131),

  /// proxy_manager æ²¡æœ‰å®ŒæˆæœåŠ¡ç«¯æ•°æ®åŒæ­¥ã€‚
  ERR_FRIENDSHIP_PROXY_NOT_SYNCED(6150),

  /// proxy_manager æ­£åœ¨è¿›è¡ŒæœåŠ¡ç«¯æ•°æ®åŒæ­¥ã€‚
  ERR_FRIENDSHIP_PROXY_SYNCING(6151),

  /// proxy_manager åŒæ­¥å¤±è´¥ã€‚
  ERR_FRIENDSHIP_PROXY_SYNCED_FAIL(6152),

  /// proxy_manager è¯·æ±‚å‚æ•°ï¼Œåœ¨æœ¬åœ°æ£€æŸ¥ä¸åˆæ³•ã€‚
  ERR_FRIENDSHIP_PROXY_LOCAL_CHECK_ERR(6153),

  /// Group assistant è¯·æ±‚å­—æ®µä¸­åŒ…å«éžé¢„è®¾å­—æ®µã€‚
  ERR_GROUP_INVALID_FIELD(6160),

  /// Group assistant ç¾¤èµ„æ–™æœ¬åœ°å­˜å‚¨æ²¡æœ‰å¼€å¯ã€‚
  ERR_GROUP_STORAGE_DISABLED(6161),

  /// åŠ è½½ç¾¤èµ„æ–™å¤±è´¥ã€‚
  ERR_LOADGRPINFO_FAILED(6162),

  /// è¯·æ±‚çš„æ—¶å€™æ²¡æœ‰ç½‘ç»œã€‚
  ERR_REQ_NO_NET_ON_REQ(6200),

  /// å“åº”çš„æ—¶å€™æ²¡æœ‰ç½‘ç»œã€‚
  ERR_REQ_NO_NET_ON_RSP(6201),

  /// QALSDK æœåŠ¡æœªå°±ç»ªã€‚
  ERR_SERIVCE_NOT_READY(6205),

  /// è´¦å·è®¤è¯å¤±è´¥ï¼ˆ TinyId è½¬æ¢å¤±è´¥ï¼‰ã€‚
  ERR_LOGIN_AUTH_FAILED(6207),

  /// åœ¨åº”ç”¨å¯åŠ¨åŽæ²¡æœ‰å°è¯•è”ç½‘ã€‚
  ERR_NEVER_CONNECT_AFTER_LAUNCH(6209),

  /// QALSDK æ‰§è¡Œå¤±è´¥ã€‚
  ERR_REQ_FAILED(6210),

  /// è¯·æ±‚éžæ³•ï¼ŒtoMsgService éžæ³•ã€‚
  ERR_REQ_INVALID_REQ(6211),

  /// è¯·æ±‚é˜Ÿåˆ—æ»¡ã€‚
  ERR_REQ_OVERLOADED(6212),

  /// å·²ç»è¢«å…¶ä»–ç»ˆç«¯è¸¢äº†ã€‚
  ERR_REQ_KICK_OFF(6213),

  /// æœåŠ¡è¢«æš‚åœã€‚
  ERR_REQ_SERVICE_SUSPEND(6214),

  /// SSO ç­¾åé”™è¯¯ã€‚
  ERR_REQ_INVALID_SIGN(6215),

  /// SSO cookie æ— æ•ˆã€‚
  ERR_REQ_INVALID_COOKIE(6216),

  /// ç™»å½•æ—¶ TLS SDK å›žåŒ…æ ¡éªŒï¼ŒåŒ…ä½“é•¿åº¦é”™è¯¯ã€‚
  ERR_LOGIN_TLS_RSP_PARSE_FAILED(6217),

  /// ç™»å½•æ—¶ OPENSTATSVC å‘ OPENMSG ä¸ŠæŠ¥çŠ¶æ€è¶…æ—¶ã€‚
  ERR_LOGIN_OPENMSG_TIMEOUT(6218),

  /// ç™»å½•æ—¶ OPENSTATSVC å‘ OPENMSG ä¸ŠæŠ¥çŠ¶æ€æ—¶è§£æžå›žåŒ…å¤±è´¥ã€‚
  ERR_LOGIN_OPENMSG_RSP_PARSE_FAILED(6219),

  /// ç™»å½•æ—¶ TLS SDK è§£å¯†å¤±è´¥ã€‚
  ERR_LOGIN_TLS_DECRYPT_FAILED(6220),

  /// WIFI éœ€è¦è®¤è¯ã€‚
  ERR_WIFI_NEED_AUTH(6221),

  /// ç”¨æˆ·å·²å–æ¶ˆã€‚
  ERR_USER_CANCELED(6222),

  /// æ¶ˆæ¯æ’¤å›žè¶…è¿‡äº†æ—¶é—´é™åˆ¶ï¼ˆé»˜è®¤2åˆ†é’Ÿï¼‰ã€‚
  ERR_REVOKE_TIME_LIMIT_EXCEED(6223),

  /// ç¼ºå°‘ UGC æ‰©å±•åŒ…ã€‚
  ERR_LACK_UGC_EXT(6224),

  /// è‡ªåŠ¨ç™»å½•ï¼Œæœ¬åœ°ç¥¨æ®è¿‡æœŸï¼Œéœ€è¦ UserSig æ‰‹åŠ¨ç™»å½•ã€‚
  ERR_AUTOLOGIN_NEED_USERSIG(6226),

  /// æ²¡æœ‰å¯ç”¨çš„çŸ­è¿žæŽ¥ SSO ã€‚
  ERR_QAL_NO_SHORT_CONN_AVAILABLE(6300),

  /// æ¶ˆæ¯å†…å®¹å®‰å…¨æ‰“å‡»ã€‚
  ERR_REQ_CONTENT_ATTACK(80101),

  /// ç™»å½•è¿”å›žï¼Œç¥¨æ®è¿‡æœŸã€‚
  ERR_LOGIN_SIG_EXPIRE(70101),

  /// IM SDK å·²ç»åˆå§‹åŒ–æ— éœ€é‡å¤åˆå§‹åŒ–ã€‚
  ERR_SDK_HAD_INITIALIZED(90101),

  /// OpenBDH é”™è¯¯ç åŸºã€‚
  ERR_OPENBDH_BASE(115000),

  /// è¯·æ±‚æ—¶æ²¡æœ‰ç½‘ç»œï¼Œè¯·ç­‰ç½‘ç»œæ¢å¤åŽé‡è¯•ã€‚
  ERR_REQUEST_NO_NET_ONREQ(6250),

  /// å“åº”æ—¶æ²¡æœ‰ç½‘ç»œï¼Œè¯·ç­‰ç½‘ç»œæ¢å¤åŽé‡è¯•ã€‚
  ERR_REQUEST_NO_NET_ONRSP(6251),

  /// QALSDK æ‰§è¡Œå¤±è´¥ã€‚
  ERR_REQUEST_FAILED(6252),

  /// è¯·æ±‚éžæ³•ï¼ŒtoMsgService éžæ³•ã€‚
  ERR_REQUEST_INVALID_REQ(6253),

  /// è¯·æ±‚é˜Ÿåˆ—æº€ã€‚
  ERR_REQUEST_OVERLOADED(6254),

  /// å·²ç»è¢«å…¶ä»–ç»ˆç«¯è¸¢äº†ã€‚
  ERR_REQUEST_KICK_OFF(6255),

  /// æœåŠ¡è¢«æš‚åœã€‚
  ERR_REQUEST_SERVICE_SUSPEND(6256),

  /// SSO ç­¾åé”™è¯¯ã€‚
  ERR_REQUEST_INVALID_SIGN(6257),

  /// SSO cookie æ— æ•ˆã€‚
  ERR_REQUEST_INVALID_COOKIE(6258);

  final int value;
  const TIMErrCode(this.value);

  static TIMErrCode fromValue(int value) => switch (value) {
        0 => ERR_SUCC,
        6015 => ERR_IN_PROGESS,
        6017 => ERR_INVALID_PARAMETERS,
        6022 => ERR_IO_OPERATION_FAILED,
        6027 => ERR_INVALID_JSON,
        6028 => ERR_OUT_OF_MEMORY,
        6001 => ERR_PARSE_RESPONSE_FAILED,
        6002 => ERR_SERIALIZE_REQ_FAILED,
        6013 => ERR_SDK_NOT_INITIALIZED,
        6005 => ERR_LOADMSG_FAILED,
        6019 => ERR_DATABASE_OPERATE_FAILED,
        7001 => ERR_SDK_COMM_CROSS_THREAD,
        7002 => ERR_SDK_COMM_TINYID_EMPTY,
        7003 => ERR_SDK_COMM_INVALID_IDENTIFIER,
        7004 => ERR_SDK_COMM_FILE_NOT_FOUND,
        7005 => ERR_SDK_COMM_FILE_TOO_LARGE,
        7006 => ERR_SDK_COMM_FILE_SIZE_EMPTY,
        7007 => ERR_SDK_COMM_FILE_OPEN_FAILED,
        7008 => ERR_SDK_COMM_API_CALL_FREQUENCY_LIMIT,
        7009 => ERR_SDK_COMM_INTERRUPT,
        7010 => ERR_SDK_COMM_DATABASE_FAILURE,
        7011 => ERR_SDK_COMM_DATABASE_NOTFOUND,
        7012 => ERR_SDK_INTERNAL_ERROR,
        7013 => ERR_SDK_INTERFACE_NOT_SUPPORT,
        7014 => ERR_SDK_INVALID_OPERATION,
        6014 => ERR_SDK_NOT_LOGGED_IN,
        6026 => ERR_NO_PREVIOUS_LOGIN,
        6206 => ERR_USER_SIG_EXPIRED,
        6208 => ERR_LOGIN_KICKED_OFF_BY_OTHER,
        7501 => ERR_SDK_ACCOUNT_LOGIN_IN_PROCESS,
        7502 => ERR_SDK_ACCOUNT_LOGOUT_IN_PROCESS,
        7503 => ERR_SDK_ACCOUNT_TLS_INIT_FAILED,
        7504 => ERR_SDK_ACCOUNT_TLS_NOT_INITIALIZED,
        7505 => ERR_SDK_ACCOUNT_TLS_TRANSPKG_ERROR,
        7506 => ERR_SDK_ACCOUNT_TLS_DECRYPT_FAILED,
        7507 => ERR_SDK_ACCOUNT_TLS_REQUEST_FAILED,
        7508 => ERR_SDK_ACCOUNT_TLS_REQUEST_TIMEOUT,
        6004 => ERR_INVALID_CONVERSATION,
        6006 => ERR_FILE_TRANS_AUTH_FAILED,
        6007 => ERR_FILE_TRANS_NO_SERVER,
        6008 => ERR_FILE_TRANS_UPLOAD_FAILED,
        6031 => ERR_IMAGE_UPLOAD_FAILED_NOTIMAGE,
        6009 => ERR_FILE_TRANS_DOWNLOAD_FAILED,
        6010 => ERR_HTTP_REQ_FAILED,
        6016 => ERR_INVALID_MSG_ELEM,
        6021 => ERR_INVALID_SDK_OBJECT,
        6032 => ERR_INVALID_MSG_RECEIVER,
        8001 => ERR_SDK_MSG_BODY_SIZE_LIMIT,
        8002 => ERR_SDK_MSG_KEY_REQ_DIFFER_RSP,
        8003 => ERR_SDK_IMAGE_CONVERT_ERROR,
        8004 => ERR_SDK_IMAGE_CI_BLOCK,
        8005 => ERR_MERGER_MSG_LAYERS_OVER_LIMIT,
        8006 => ERR_SDK_MSG_MODIFY_CONFLICT,
        8010 => ERR_SDK_SIGNALING_INVALID_INVITE_ID,
        8011 => ERR_SDK_SIGNALING_NO_PERMISSION,
        8020 => ERR_SDK_INVALID_CANCEL_MESSAGE,
        8021 => ERR_SDK_SEND_MESSAGE_FAILED_WITH_CANCEL,
        8501 => ERR_SDK_GROUP_INVALID_ID,
        8502 => ERR_SDK_GROUP_INVALID_NAME,
        8503 => ERR_SDK_GROUP_INVALID_INTRODUCTION,
        8504 => ERR_SDK_GROUP_INVALID_NOTIFICATION,
        8505 => ERR_SDK_GROUP_INVALID_FACE_URL,
        8506 => ERR_SDK_GROUP_INVALID_NAME_CARD,
        8507 => ERR_SDK_GROUP_MEMBER_COUNT_LIMIT,
        8508 => ERR_SDK_GROUP_JOIN_PRIVATE_GROUP_DENY,
        8509 => ERR_SDK_GROUP_INVITE_SUPER_DENY,
        8510 => ERR_SDK_GROUP_INVITE_NO_MEMBER,
        8511 => ERR_SDK_GROUP_ATTR_FREQUENCY_LIMIT,
        8512 => ERR_SDK_GROUP_GET_ONLINE_MEMBER_COUNT_LIMIT,
        8513 => ERR_SDK_GROUP_GET_GROUPS_INFO_LIMIT,
        8514 => ERR_SDK_GROUP_GET_JOINED_GROUP_LIMIT,
        9001 => ERR_SDK_FRIENDSHIP_INVALID_PROFILE_KEY,
        9002 => ERR_SDK_FRIENDSHIP_INVALID_ADD_REMARK,
        9003 => ERR_SDK_FRIENDSHIP_INVALID_ADD_WORDING,
        9004 => ERR_SDK_FRIENDSHIP_INVALID_ADD_SOURCE,
        9005 => ERR_SDK_FRIENDSHIP_FRIEND_GROUP_EMPTY,
        9006 => ERR_SDK_FRIENDSHIP_EXCEED_THE_LIMIT,
        9501 => ERR_SDK_NET_ENCODE_FAILED,
        9502 => ERR_SDK_NET_DECODE_FAILED,
        9503 => ERR_SDK_NET_AUTH_INVALID,
        9504 => ERR_SDK_NET_COMPRESS_FAILED,
        9505 => ERR_SDK_NET_UNCOMPRESS_FAILED,
        9506 => ERR_SDK_NET_FREQ_LIMIT,
        9507 => ERR_SDK_NET_REQ_COUNT_LIMIT,
        9508 => ERR_SDK_NET_DISCONNECT,
        9509 => ERR_SDK_NET_ALLREADY_CONN,
        9510 => ERR_SDK_NET_CONN_TIMEOUT,
        9511 => ERR_SDK_NET_CONN_REFUSE,
        9512 => ERR_SDK_NET_NET_UNREACH,
        9513 => ERR_SDK_NET_SOCKET_NO_BUFF,
        9514 => ERR_SDK_NET_RESET_BY_PEER,
        9515 => ERR_SDK_NET_SOCKET_INVALID,
        9516 => ERR_SDK_NET_HOST_GETADDRINFO_FAILED,
        9517 => ERR_SDK_NET_CONNECT_RESET,
        9518 => ERR_SDK_NET_WAIT_INQUEUE_TIMEOUT,
        9519 => ERR_SDK_NET_WAIT_SEND_TIMEOUT,
        9520 => ERR_SDK_NET_WAIT_ACK_TIMEOUT,
        9521 => ERR_SDK_NET_WAIT_SEND_REMAINING_TIMEOUT,
        9522 => ERR_SDK_NET_PKG_SIZE_LIMIT,
        9523 => ERR_SDK_NET_WAIT_SEND_TIMEOUT_NO_NETWORK,
        9524 => ERR_SDK_NET_WAIT_ACK_TIMEOUT_NO_NETWORK,
        9525 => ERR_SDK_NET_SEND_REMAINING_TIMEOUT_NO_NETWORK,
        -302 => ERR_SVR_SSO_CONNECT_LIMIT,
        -10000 => ERR_SVR_SSO_VCODE,
        -10001 => ERR_SVR_SSO_D2_EXPIRED,
        -10003 => ERR_SVR_SSO_A2_UP_INVALID,
        -10004 => ERR_SVR_SSO_A2_DOWN_INVALID,
        -10005 => ERR_SVR_SSO_EMPTY_KEY,
        -10006 => ERR_SVR_SSO_UIN_INVALID,
        -10007 => ERR_SVR_SSO_VCODE_TIMEOUT,
        -10008 => ERR_SVR_SSO_NO_IMEI_AND_A2,
        -10009 => ERR_SVR_SSO_COOKIE_INVALID,
        -10101 => ERR_SVR_SSO_DOWN_TIP,
        -10102 => ERR_SVR_SSO_DISCONNECT,
        -10103 => ERR_SVR_SSO_IDENTIFIER_INVALID,
        -10104 => ERR_SVR_SSO_CLIENT_CLOSE,
        -10105 => ERR_SVR_SSO_MSFSDK_QUIT,
        -10106 => ERR_SVR_SSO_D2KEY_WRONG,
        -10107 => ERR_SVR_SSO_UNSURPPORT,
        -10108 => ERR_SVR_SSO_PREPAID_ARREARS,
        -10109 => ERR_SVR_SSO_PACKET_WRONG,
        -10110 => ERR_SVR_SSO_APPID_BLACK_LIST,
        -10111 => ERR_SVR_SSO_CMD_BLACK_LIST,
        -10112 => ERR_SVR_SSO_APPID_WITHOUT_USING,
        -10113 => ERR_SVR_SSO_FREQ_LIMIT,
        -10114 => ERR_SVR_SSO_OVERLOAD,
        -20009 => ERR_SVR_SSO_FREQUENCY_LIMIT,
        114000 => ERR_SVR_RES_NOT_FOUND,
        114001 => ERR_SVR_RES_ACCESS_DENY,
        114002 => ERR_SVR_RES_SIZE_LIMIT,
        114003 => ERR_SVR_RES_SEND_CANCEL,
        114004 => ERR_SVR_RES_READ_FAILED,
        114005 => ERR_SVR_RES_TRANSFER_TIMEOUT,
        114011 => ERR_SVR_RES_INVALID_PARAMETERS,
        115066 => ERR_SVR_RES_INVALID_FILE_MD5,
        115068 => ERR_SVR_RES_INVALID_PART_MD5,
        60002 => ERR_SVR_COMM_INVALID_HTTP_URL,
        60003 => ERR_SVR_COMM_REQ_JSON_PARSE_FAILED,
        60004 => ERR_SVR_COMM_INVALID_ACCOUNT,
        60005 => ERR_SVR_COMM_INVALID_ACCOUNT_EX,
        60006 => ERR_SVR_COMM_INVALID_SDKAPPID,
        60007 => ERR_SVR_COMM_REST_FREQ_LIMIT,
        60008 => ERR_SVR_COMM_REQUEST_TIMEOUT,
        60009 => ERR_SVR_COMM_INVALID_RES,
        60010 => ERR_SVR_COMM_ID_NOT_ADMIN,
        60011 => ERR_SVR_COMM_SDKAPPID_FREQ_LIMIT,
        60012 => ERR_SVR_COMM_SDKAPPID_MISS,
        60013 => ERR_SVR_COMM_RSP_JSON_PARSE_FAILED,
        60014 => ERR_SVR_COMM_EXCHANGE_ACCOUNT_TIMEUT,
        60015 => ERR_SVR_COMM_INVALID_ID_FORMAT,
        60016 => ERR_SVR_COMM_SDKAPPID_FORBIDDEN,
        60017 => ERR_SVR_COMM_REQ_FORBIDDEN,
        60018 => ERR_SVR_COMM_REQ_FREQ_LIMIT,
        60019 => ERR_SVR_COMM_REQ_FREQ_LIMIT_EX,
        60020 => ERR_SVR_COMM_INVALID_SERVICE,
        80001 => ERR_SVR_COMM_SENSITIVE_TEXT,
        80002 => ERR_SVR_COMM_BODY_SIZE_LIMIT,
        80003 => ERR_SVR_COMM_PRE_HOOK_FAILED,
        80004 => ERR_SVR_COMM_SENSITIVE_IMAGE,
        80005 => ERR_SVR_COMM_SERVICE_DISABLED,
        70001 => ERR_SVR_ACCOUNT_USERSIG_EXPIRED,
        70002 => ERR_SVR_ACCOUNT_USERSIG_EMPTY,
        70003 => ERR_SVR_ACCOUNT_USERSIG_CHECK_FAILED,
        70005 => ERR_SVR_ACCOUNT_USERSIG_CHECK_FAILED_EX,
        70009 => ERR_SVR_ACCOUNT_USERSIG_MISMATCH_PUBLICKEY,
        70013 => ERR_SVR_ACCOUNT_USERSIG_MISMATCH_ID,
        70014 => ERR_SVR_ACCOUNT_USERSIG_MISMATCH_SDKAPPID,
        70016 => ERR_SVR_ACCOUNT_USERSIG_PUBLICKEY_NOT_FOUND,
        70020 => ERR_SVR_ACCOUNT_SDKAPPID_NOT_FOUND,
        70052 => ERR_SVR_ACCOUNT_INVALID_USERSIG,
        70107 => ERR_SVR_ACCOUNT_NOT_FOUND,
        70114 => ERR_SVR_ACCOUNT_SEC_RSTR,
        70169 => ERR_SVR_ACCOUNT_INTERNAL_TIMEOUT,
        70206 => ERR_SVR_ACCOUNT_INVALID_COUNT,
        70402 => ERR_SVR_ACCOUNT_INVALID_PARAMETERS,
        70403 => ERR_SVR_ACCOUNT_ADMIN_REQUIRED,
        70050 => ERR_SVR_ACCOUNT_FREQ_LIMIT,
        70051 => ERR_SVR_ACCOUNT_BLACKLIST,
        70398 => ERR_SVR_ACCOUNT_COUNT_LIMIT,
        70500 => ERR_SVR_ACCOUNT_INTERNAL_ERROR,
        72001 => ERR_SVR_ACCOUNT_USER_STATUS_DISABLED,
        40001 => ERR_SVR_PROFILE_INVALID_PARAMETERS,
        40002 => ERR_SVR_PROFILE_ACCOUNT_MISS,
        40003 => ERR_SVR_PROFILE_ACCOUNT_NOT_FOUND,
        40004 => ERR_SVR_PROFILE_ADMIN_REQUIRED,
        40005 => ERR_SVR_PROFILE_SENSITIVE_TEXT,
        40006 => ERR_SVR_PROFILE_INTERNAL_ERROR,
        40007 => ERR_SVR_PROFILE_READ_PERMISSION_REQUIRED,
        40008 => ERR_SVR_PROFILE_WRITE_PERMISSION_REQUIRED,
        40009 => ERR_SVR_PROFILE_TAG_NOT_FOUND,
        40601 => ERR_SVR_PROFILE_SIZE_LIMIT,
        40605 => ERR_SVR_PROFILE_VALUE_ERROR,
        40610 => ERR_SVR_PROFILE_INVALID_VALUE_FORMAT,
        72012 => ERR_SVR_PROFILE_SUBSCRIPTION_DISABLED,
        30001 => ERR_SVR_FRIENDSHIP_INVALID_PARAMETERS,
        30002 => ERR_SVR_FRIENDSHIP_INVALID_SDKAPPID,
        30003 => ERR_SVR_FRIENDSHIP_ACCOUNT_NOT_FOUND,
        30004 => ERR_SVR_FRIENDSHIP_ADMIN_REQUIRED,
        30005 => ERR_SVR_FRIENDSHIP_SENSITIVE_TEXT,
        30006 => ERR_SVR_FRIENDSHIP_INTERNAL_ERROR,
        30007 => ERR_SVR_FRIENDSHIP_NET_TIMEOUT,
        30008 => ERR_SVR_FRIENDSHIP_WRITE_CONFLICT,
        30009 => ERR_SVR_FRIENDSHIP_ADD_FRIEND_DENY,
        30010 => ERR_SVR_FRIENDSHIP_COUNT_LIMIT,
        30011 => ERR_SVR_FRIENDSHIP_GROUP_COUNT_LIMIT,
        30012 => ERR_SVR_FRIENDSHIP_PENDENCY_LIMIT,
        30013 => ERR_SVR_FRIENDSHIP_BLACKLIST_LIMIT,
        30014 => ERR_SVR_FRIENDSHIP_PEER_FRIEND_LIMIT,
        30015 => ERR_SVR_FRIENDSHIP_ALREADY_FRIENDS,
        30515 => ERR_SVR_FRIENDSHIP_IN_SELF_BLACKLIST,
        30516 => ERR_SVR_FRIENDSHIP_ALLOW_TYPE_DENY_ANY,
        30525 => ERR_SVR_FRIENDSHIP_IN_PEER_BLACKLIST,
        30539 => ERR_SVR_FRIENDSHIP_ALLOW_TYPE_NEED_CONFIRM,
        30540 => ERR_SVR_FRIENDSHIP_ADD_FRIEND_SEC_RSTR,
        30614 => ERR_SVR_FRIENDSHIP_PENDENCY_NOT_FOUND,
        31704 => ERR_SVR_FRIENDSHIP_DEL_NONFRIEND,
        31707 => ERR_SVR_FRIENDSHIP_DEL_FRIEND_SEC_RSTR,
        31804 => ERR_SVR_FRIENDSHIP_ACCOUNT_NOT_FOUND_EX,
        32100 => ERR_SVR_FRIENDSHIP_SELF_FOLLOWING_COUNT_EXCEEDS_LIMIT,
        32101 => ERR_SVR_FRIENDSHIP_PEER_FOLLOWERS_COUNT_EXCEEDS_LIMIT,
        32102 => ERR_SVR_FRIENDSHIP_SELF_MUTUAL_FOLLOWERS_COUNT_EXCEEDS_LIMIT,
        32103 => ERR_SVR_FRIENDSHIP_PEER_MUTUAL_FOLLOWERS_COUNT_EXCEEDS_LIMIT,
        50001 => ERR_SVR_CONV_ACCOUNT_NOT_FOUND,
        50002 => ERR_SVR_CONV_INVALID_PARAMETERS,
        50003 => ERR_SVR_CONV_ADMIN_REQUIRED,
        50004 => ERR_SVR_CONV_INTERNAL_ERROR,
        50005 => ERR_SVR_CONV_NET_TIMEOUT,
        51006 => ERR_SVR_CONV_CONV_MARK_REQ_COUNT_EXCEED_LIMIT,
        51007 => ERR_SVR_CONV_CONV_MARK_OPERATE_FAILED,
        51008 => ERR_SVR_CONV_CONV_MARK_TOTAL_COUNT_EXCEED_LIMIT,
        51009 => ERR_SVR_CONV_CONV_GROUP_NOT_EXIST,
        51010 => ERR_SVR_CONV_CONV_GROUP_TOTAL_COUNT_EXCEED_LIMIT,
        51011 => ERR_SVR_CONV_CONV_GROUP_NAME_EXCEED_LENGTH,
        20001 => ERR_SVR_MSG_PKG_PARSE_FAILED,
        20002 => ERR_SVR_MSG_INTERNAL_AUTH_FAILED,
        20003 => ERR_SVR_MSG_INVALID_ID,
        20004 => ERR_SVR_MSG_NET_ERROR,
        20005 => ERR_SVR_MSG_INTERNAL_ERROR1,
        20006 => ERR_SVR_MSG_PUSH_DENY,
        20007 => ERR_SVR_MSG_IN_PEER_BLACKLIST,
        20009 => ERR_SVR_MSG_BOTH_NOT_FRIEND,
        20010 => ERR_SVR_MSG_NOT_PEER_FRIEND,
        20011 => ERR_SVR_MSG_NOT_SELF_FRIEND,
        20012 => ERR_SVR_MSG_SHUTUP_DENY,
        20016 => ERR_SVR_MSG_REVOKE_TIME_LIMIT,
        20018 => ERR_SVR_MSG_DEL_RAMBLE_INTERNAL_ERROR,
        23001 => ERR_SVR_MSG_EXTENSION_CONFLICT,
        23004 => ERR_SVR_MSG_EXTENSION_NOT_EXIST,
        23005 => ERR_SVR_MSG_REACTION_COUNT_LIMIT,
        23006 => ERR_SVR_MSG_REACTION_USER_COUNT_LIMIT,
        23007 => ERR_SVR_MSG_REACTION_ALREADY_CONTAIN_USER,
        23008 => ERR_SVR_MSG_REACTION_NOT_EXISTS,
        23009 => ERR_SVR_MSG_REACTION_NOT_CONTAIN_USER,
        90001 => ERR_SVR_MSG_JSON_PARSE_FAILED,
        90002 => ERR_SVR_MSG_INVALID_JSON_BODY_FORMAT,
        90003 => ERR_SVR_MSG_INVALID_TO_ACCOUNT,
        90005 => ERR_SVR_MSG_INVALID_RAND,
        90006 => ERR_SVR_MSG_INVALID_TIMESTAMP,
        90007 => ERR_SVR_MSG_BODY_NOT_ARRAY,
        90009 => ERR_SVR_MSG_ADMIN_REQUIRED,
        90010 => ERR_SVR_MSG_INVALID_JSON_FORMAT,
        90011 => ERR_SVR_MSG_TO_ACCOUNT_COUNT_LIMIT,
        90012 => ERR_SVR_MSG_TO_ACCOUNT_NOT_FOUND,
        90026 => ERR_SVR_MSG_TIME_LIMIT,
        90031 => ERR_SVR_MSG_INVALID_SYNCOTHERMACHINE,
        90044 => ERR_SVR_MSG_INVALID_MSGLIFETIME,
        90048 => ERR_SVR_MSG_ACCOUNT_NOT_FOUND,
        90994 => ERR_SVR_MSG_INTERNAL_ERROR2,
        90995 => ERR_SVR_MSG_INTERNAL_ERROR3,
        91000 => ERR_SVR_MSG_INTERNAL_ERROR4,
        90992 => ERR_SVR_MSG_INTERNAL_ERROR5,
        93000 => ERR_SVR_MSG_BODY_SIZE_LIMIT,
        91101 => ERR_SVR_MSG_LONGPOLLING_COUNT_LIMIT,
        10002 => ERR_SVR_GROUP_INTERNAL_ERROR,
        10003 => ERR_SVR_GROUP_API_NAME_ERROR,
        10004 => ERR_SVR_GROUP_INVALID_PARAMETERS,
        10005 => ERR_SVR_GROUP_ACOUNT_COUNT_LIMIT,
        10006 => ERR_SVR_GROUP_FREQ_LIMIT,
        10007 => ERR_SVR_GROUP_PERMISSION_DENY,
        10008 => ERR_SVR_GROUP_INVALID_REQ,
        10009 => ERR_SVR_GROUP_SUPER_NOT_ALLOW_QUIT,
        10010 => ERR_SVR_GROUP_NOT_FOUND,
        10011 => ERR_SVR_GROUP_JSON_PARSE_FAILED,
        10012 => ERR_SVR_GROUP_INVALID_ID,
        10013 => ERR_SVR_GROUP_ALLREADY_MEMBER,
        10014 => ERR_SVR_GROUP_FULL_MEMBER_COUNT,
        10015 => ERR_SVR_GROUP_INVALID_GROUPID,
        10016 => ERR_SVR_GROUP_REJECT_FROM_THIRDPARTY,
        10017 => ERR_SVR_GROUP_SHUTUP_DENY,
        10018 => ERR_SVR_GROUP_RSP_SIZE_LIMIT,
        10019 => ERR_SVR_GROUP_ACCOUNT_NOT_FOUND,
        10021 => ERR_SVR_GROUP_GROUPID_IN_USED,
        10023 => ERR_SVR_GROUP_SEND_MSG_FREQ_LIMIT,
        10024 => ERR_SVR_GROUP_REQ_ALLREADY_BEEN_PROCESSED,
        10025 => ERR_SVR_GROUP_GROUPID_IN_USED_FOR_SUPER,
        10026 => ERR_SVR_GROUP_SDKAPPID_DENY,
        10030 => ERR_SVR_GROUP_REVOKE_MSG_NOT_FOUND,
        10031 => ERR_SVR_GROUP_REVOKE_MSG_TIME_LIMIT,
        10032 => ERR_SVR_GROUP_REVOKE_MSG_DENY,
        10033 => ERR_SVR_GROUP_NOT_ALLOW_REVOKE_MSG,
        10034 => ERR_SVR_GROUP_REMOVE_MSG_DENY,
        10035 => ERR_SVR_GROUP_NOT_ALLOW_REMOVE_MSG,
        10036 => ERR_SVR_GROUP_AVCHATROOM_COUNT_LIMIT,
        10037 => ERR_SVR_GROUP_COUNT_LIMIT,
        10038 => ERR_SVR_GROUP_MEMBER_COUNT_LIMIT,
        10056 => ERR_SVR_GROUP_ATTRIBUTE_WRITE_CONFILCT,
        10070 => ERR_SVR_GROUP_PINNED_MESSAGE_COUNT_LIMIT,
        10071 => ERR_SVR_GROUP_MESSAGE_ALREADY_PINNED,
        6003 => ERR_NO_SUCC_RESULT,
        6011 => ERR_TO_USER_INVALID,
        6012 => ERR_REQUEST_TIME_OUT,
        6018 => ERR_INIT_CORE_FAIL,
        6020 => ERR_EXPIRED_SESSION_NODE,
        6023 => ERR_LOGGED_OUT_BEFORE_LOGIN_FINISHED,
        6024 => ERR_TLSSDK_NOT_INITIALIZED,
        6025 => ERR_TLSSDK_USER_NOT_FOUND,
        6100 => ERR_BIND_FAIL_UNKNOWN,
        6101 => ERR_BIND_FAIL_NO_SSOTICKET,
        6102 => ERR_BIND_FAIL_REPEATD_BIND,
        6103 => ERR_BIND_FAIL_TINYID_NULL,
        6104 => ERR_BIND_FAIL_GUID_NULL,
        6105 => ERR_BIND_FAIL_UNPACK_REGPACK_FAILED,
        6106 => ERR_BIND_FAIL_REG_TIMEOUT,
        6107 => ERR_BIND_FAIL_ISBINDING,
        6120 => ERR_PACKET_FAIL_UNKNOWN,
        6121 => ERR_PACKET_FAIL_REQ_NO_NET,
        6122 => ERR_PACKET_FAIL_RESP_NO_NET,
        6123 => ERR_PACKET_FAIL_REQ_NO_AUTH,
        6124 => ERR_PACKET_FAIL_SSO_ERR,
        6125 => ERR_PACKET_FAIL_REQ_TIMEOUT,
        6126 => ERR_PACKET_FAIL_RESP_TIMEOUT,
        6127 => ERR_PACKET_FAIL_REQ_ON_RESEND,
        6128 => ERR_PACKET_FAIL_RESP_NO_RESEND,
        6129 => ERR_PACKET_FAIL_FLOW_SAVE_FILTERED,
        6130 => ERR_PACKET_FAIL_REQ_OVER_LOAD,
        6131 => ERR_PACKET_FAIL_LOGIC_ERR,
        6150 => ERR_FRIENDSHIP_PROXY_NOT_SYNCED,
        6151 => ERR_FRIENDSHIP_PROXY_SYNCING,
        6152 => ERR_FRIENDSHIP_PROXY_SYNCED_FAIL,
        6153 => ERR_FRIENDSHIP_PROXY_LOCAL_CHECK_ERR,
        6160 => ERR_GROUP_INVALID_FIELD,
        6161 => ERR_GROUP_STORAGE_DISABLED,
        6162 => ERR_LOADGRPINFO_FAILED,
        6200 => ERR_REQ_NO_NET_ON_REQ,
        6201 => ERR_REQ_NO_NET_ON_RSP,
        6205 => ERR_SERIVCE_NOT_READY,
        6207 => ERR_LOGIN_AUTH_FAILED,
        6209 => ERR_NEVER_CONNECT_AFTER_LAUNCH,
        6210 => ERR_REQ_FAILED,
        6211 => ERR_REQ_INVALID_REQ,
        6212 => ERR_REQ_OVERLOADED,
        6213 => ERR_REQ_KICK_OFF,
        6214 => ERR_REQ_SERVICE_SUSPEND,
        6215 => ERR_REQ_INVALID_SIGN,
        6216 => ERR_REQ_INVALID_COOKIE,
        6217 => ERR_LOGIN_TLS_RSP_PARSE_FAILED,
        6218 => ERR_LOGIN_OPENMSG_TIMEOUT,
        6219 => ERR_LOGIN_OPENMSG_RSP_PARSE_FAILED,
        6220 => ERR_LOGIN_TLS_DECRYPT_FAILED,
        6221 => ERR_WIFI_NEED_AUTH,
        6222 => ERR_USER_CANCELED,
        6223 => ERR_REVOKE_TIME_LIMIT_EXCEED,
        6224 => ERR_LACK_UGC_EXT,
        6226 => ERR_AUTOLOGIN_NEED_USERSIG,
        6300 => ERR_QAL_NO_SHORT_CONN_AVAILABLE,
        80101 => ERR_REQ_CONTENT_ATTACK,
        70101 => ERR_LOGIN_SIG_EXPIRE,
        90101 => ERR_SDK_HAD_INITIALIZED,
        115000 => ERR_OPENBDH_BASE,
        6250 => ERR_REQUEST_NO_NET_ONREQ,
        6251 => ERR_REQUEST_NO_NET_ONRSP,
        6252 => ERR_REQUEST_FAILED,
        6253 => ERR_REQUEST_INVALID_REQ,
        6254 => ERR_REQUEST_OVERLOADED,
        6255 => ERR_REQUEST_KICK_OFF,
        6256 => ERR_REQUEST_SERVICE_SUSPEND,
        6257 => ERR_REQUEST_INVALID_SIGN,
        6258 => ERR_REQUEST_INVALID_COOKIE,
        _ => throw ArgumentError("Unknown value for TIMErrCode: $value"),
      };
}
/// 1.9 ç¾¤æ¶ˆæ¯å·²è¯»æˆå‘˜åˆ—è¡¨è¿‡æ»¤
enum TIMGroupMessageReadMembersFilter {
  /// ç¾¤æ¶ˆæ¯å·²è¯»æˆå‘˜åˆ—è¡¨
  TIM_GROUP_MESSAGE_READ_MEMBERS_FILTER_READ(0),

  /// ç¾¤æ¶ˆæ¯æœªè¯»æˆå‘˜åˆ—è¡¨
  TIM_GROUP_MESSAGE_READ_MEMBERS_FILTER_UNREAD(1);

  final int value;
  const TIMGroupMessageReadMembersFilter(this.value);

  static TIMGroupMessageReadMembersFilter fromValue(int value) =>
      switch (value) {
        0 => TIM_GROUP_MESSAGE_READ_MEMBERS_FILTER_READ,
        1 => TIM_GROUP_MESSAGE_READ_MEMBERS_FILTER_UNREAD,
        _ => throw ArgumentError(
            "Unknown value for TIMGroupMessageReadMembersFilter: $value"),
      };
}
