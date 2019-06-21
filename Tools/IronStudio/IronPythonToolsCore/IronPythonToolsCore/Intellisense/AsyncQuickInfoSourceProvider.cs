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
using System.Threading;
using System.Threading.Tasks;
using System.ComponentModel.Composition;
using Microsoft.VisualStudio.Language.Intellisense;
using Microsoft.VisualStudio.Shell;
using Microsoft.VisualStudio.Text;
using Microsoft.VisualStudio.Utilities;

namespace Microsoft.IronPythonTools.Intellisense
{
    [Export(typeof(IAsyncQuickInfoSourceProvider)), ContentType(PythonCoreConstants.ContentType), Order, Name("IronPython Quick Info Source")]
    class QuickInfoSourceProvider : IAsyncQuickInfoSourceProvider
    {
        private readonly IServiceProvider _serviceProvider;

        [ImportingConstructor]
        public QuickInfoSourceProvider([Import(typeof(SVsServiceProvider))]IServiceProvider serviceProvider)
        {
            _serviceProvider = serviceProvider;
        }

        public IAsyncQuickInfoSource TryCreateQuickInfoSource(ITextBuffer textBuffer)
        {
            return new AsyncQuickInfoSource(textBuffer);
        }
    }
}