/* ****************************************************************************
 *
 * Copyright (c) Microsoft Corporation. 
 *
 * This source code is subject to terms and conditions of the Apache License, Version 2.0. A 
 * copy of the license can be found in the License.html file at the root of this distribution. If 
 * you cannot locate the Apache License, Version 2.0, please send an email to 
 * ironpy@microsoft.com. By using this source code in any fashion, you are agreeing to be bound 
 * by the terms of the Apache License, Version 2.0.
 *
 * You must not remove this notice, or any other, from this software.
 *
 * ***************************************************************************/

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using Microsoft.IronPythonTools.Internal;
using Microsoft.PyAnalysis;
using Microsoft.VisualStudio.Language;
using Microsoft.VisualStudio.Language.Intellisense;
using Microsoft.VisualStudio.Text;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.VisualStudio.Text.Editor;

namespace Microsoft.IronPythonTools.Intellisense
{
    internal class AsyncQuickInfoSource : IAsyncQuickInfoSource
    {
        private readonly ITextBuffer _textBuffer;
        private volatile IAsyncQuickInfoSession _curSession;

        public AsyncQuickInfoSource(ITextBuffer textBuffer)
        {
            _textBuffer = textBuffer;
        }

        #region IAsyncQuickInfoSource Members
        public async Task<QuickInfoItem> GetQuickInfoItemAsync(IAsyncQuickInfoSession session, CancellationToken cancellationToken)
        {
            if (_curSession != null && _curSession.State != QuickInfoSessionState.Dismissed)
            {
                await _curSession.DismissAsync();
                _curSession = null;
            }

            _curSession = session;
            _curSession.StateChanged += CurSessionStateChanged;

            var quickInfo = GetQuickInfo(session.TextView);
            return quickInfo != null ? new QuickInfoItem(quickInfo.Span, quickInfo.Text) : null;
        }

        public static void AddQuickInfo(ITextView view, QuickInfo info) => view.Properties[typeof(QuickInfo)] = info;

        private static QuickInfo GetQuickInfo(ITextView view)
            => view.Properties.TryGetProperty(typeof(QuickInfo), out QuickInfo quickInfo) ? quickInfo : null;

        private void CurSessionStateChanged(object sender, QuickInfoSessionStateChangedEventArgs e)
            => _curSession = null;

        #endregion

        public void Dispose() { }
    }
}