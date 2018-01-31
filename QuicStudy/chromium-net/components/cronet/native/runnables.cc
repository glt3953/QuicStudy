// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "components/cronet/native/runnables.h"

#include <utility>

namespace cronet {

void BaseCronet_Runnable::SetContext(Cronet_RunnableContext context) {
  context_ = context;
}

Cronet_RunnableContext BaseCronet_Runnable::GetContext() {
  return context_;
}

OnceClosureRunnable::OnceClosureRunnable(base::OnceClosure task)
    : task_(std::move(task)) {}

OnceClosureRunnable::~OnceClosureRunnable() = default;

void OnceClosureRunnable::Run() {
  std::move(task_).Run();
}

}  // namespace cronet
